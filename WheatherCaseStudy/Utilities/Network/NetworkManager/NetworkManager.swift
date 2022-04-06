//
//  NetworkManager.swift
//  WheatherCaseStudy
//
//  Created by Tuğrulcan on 24.03.2022.
//

import Foundation
import Combine



enum httpRequestType{
    case bodyRequest
    case queryRequest
    case headerRequest
}

protocol EndpointType{
    var baseURL:URL {get set}
    var path:String {get set}
    var httpMethod:HTTPMethod {get set}
    var task:URL {get set}
    var headers:URL {get set}
    
}

enum HTTPMethod: String{
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

typealias Parameters = [String:Any]
typealias HTTPHeaders = [String:String]

enum HTTPTask{
    case request
    case requestParameters(bodyParameters:Parameters)
    case requestParametersAndHeaders
}


protocol NetworkManagerProtocol:AnyObject{
    static var shared:NetworkManager {get set}
    
    func getRequestCombine(endPointUrl:String)->AnyPublisher<Data,Error>
    
    func post<T:Codable>(endpointUrl:String,params:T) ->AnyPublisher<Data,Error>
    
    func post<T:Codable,U:Codable>(url:String,params:T,completion:@escaping ((Result<U,NetworkingError>)->()))
    
    func newGetRequest<T:Codable>(endpoint:Endpoint,completion:@escaping (Result<T,NetworkingError>)->Void)
}

final class NetworkManager:NetworkManagerProtocol{
    
    static var shared:NetworkManager = NetworkManager()
    
    private init(){
  
    }
  
    
    enum NetworkingErrorCombine : LocalizedError{
            case badURLResponse(url:URL)
            case unowned
            
            var errorDescription: String?{
                switch self {
                case .badURLResponse(url : let url):
                    return "[🔥] Bad Response from Url: \(url) "
                case .unowned:
                    return "[⚠️] Unknown error occured"
                }
            }
    }

    ///
    ///Combine Framework te kullanılabilir
    ///örnek :
    ///getRequestCombine()
    ///.decode(T.self)
    ///.sink(res:Data)
    ///.store(cancellable:&cancellable)
    ///
    ///
    @available(iOS 13, *)
    func getRequestCombine(endPointUrl:String)->AnyPublisher<Data,Error>{
            let url = URL(string: endPointUrl)
            guard let url = url else {
                return AnyPublisher(Fail<Data,Error>(error: URLError(.badURL)))
            }

            return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap{try NetworkManager.handleUrlResponse(output: $0,url: url)}
                .eraseToAnyPublisher()
    }
    
    
    
    @available(iOS 13, *)
    func post<T:Codable>(endpointUrl:String,params:T) ->AnyPublisher<Data,Error>{
          //        let jsonType = try JSONSerialization.jsonObject(with: params, options: [])
          let encoder = JSONEncoder()
          
          encoder.outputFormatting = .prettyPrinted
          let data = try? encoder.encode(params)
          guard let url = URL(string: endpointUrl) else {
              return AnyPublisher(Fail<Data,Error>(error: URLError(.badURL)))
          }
          var request = URLRequest(url: url)
          request.setValue("application/json", forHTTPHeaderField: "Content-Type")
          request.httpMethod = "POST"
          request.httpBody = data
          
          
          return URLSession.shared.dataTaskPublisher(for: request)
              .tryMap { (data,response) -> Data in
                  guard let response = response as? HTTPURLResponse, response.statusCode >= 200 && response.statusCode < 300 else{
                      throw URLError(.badServerResponse)
                  }
                  return data
              }
              .eraseToAnyPublisher()
      }
        
    
  
    
    
    static func handleUrlResponse(output: URLSession.DataTaskPublisher.Output,url:URL) throws -> Data{
            guard let response = output.response as? HTTPURLResponse ,  response.statusCode >= 200 && response.statusCode < 300 else {
                throw NetworkingErrorCombine.badURLResponse(url: url)
            }
            return output.data
    }
    
    static func handleCompletion(completion:Subscribers.Completion<Error>){
            switch completion{
            case .finished:
                break
            case .failure(let err):
                print(err.localizedDescription)
                
            }
        }
        
    
    
    func post<T:Codable,U:Codable>(url:String,params:T,completion:@escaping ((Result<U,NetworkingError>)->())){
        guard let url = URL(string: url) else {
            return completion(.failure(.UrlError(reason: "URL Hatası")))
            
        }
        
        guard let jsonParse = try? JSONEncoder().encode(params) else {
            return completion(.failure(.ParamsDecodeError(reason: "Json parse hatası")))
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonParse
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error != nil else {
                return completion(.failure(.error(error!.localizedDescription)))
            }
            
            guard let response = response as? HTTPURLResponse , response.statusCode >= 200 && response.statusCode < 300 else {
                return completion(.failure(.urlResponseError(URLError.init(.badServerResponse))))
                
            }
            guard let data = data else {
                return
            }
            do {
                let responseData = try JSONDecoder().decode(U.self, from: data)
                // BURASI DÜZELTİLECEK
                DispatchQueue.main.async {
                    completion(.success(responseData))
                }
            } catch let error {
                completion(.failure(.decodeError(error)))
            }
        }
        .resume()
    }
    

    
    func getRequest<T:Codable>(url:String,completion:@escaping (Result<T,NetworkingError>)->Void){
        guard let url = URL(string: url) else {
            return completion(.failure(.UrlError(reason: "URL Hatası")))
            
        }
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                return completion(.failure(.error(error?.localizedDescription ?? "hata ")))
            }
            
            guard let response = response as? HTTPURLResponse , response.statusCode >= 200 && response.statusCode < 300 else {
                return completion(.failure(.urlResponseError(URLError.init(.badServerResponse))))
                
            }
            guard let data = data else {
                return
            }
            do {
                let responseData = try JSONDecoder().decode(T.self, from: data)
                // BURASI DÜZELTİLECEK ??
                DispatchQueue.main.async {
                    completion(.success(responseData))
                }
            } catch let error {
                completion(.failure(.decodeError(error)))
            }
        }
        .resume()
        

    
}
    
    
    func newGetRequest<T:Codable>(endpoint:Endpoint,completion:@escaping (Result<T,NetworkingError>)->Void){
        
        
        let url = endpoint.createUrl()
        
        
        guard let url = url else {
            return completion(.failure(.UrlError(reason: "URL Hatası")))
            
        }
        var request = URLRequest(url: url)
        
        request.httpMethod = endpoint.httpMethod.rawValue
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                return completion(.failure(.error(error?.localizedDescription ?? "hata ")))
            }
            
            guard let response = response as? HTTPURLResponse , response.statusCode >= 200 && response.statusCode < 300 else {
                return completion(.failure(.urlResponseError(URLError.init(.badServerResponse))))
                
            }
            guard let data = data else {
                return
            }
            do {
                let responseData = try JSONDecoder().decode(T.self, from: data)
                // BURASI DÜZELTİLECEK ??
                DispatchQueue.main.async {
                    completion(.success(responseData))
                }
            } catch let error {
                completion(.failure(.decodeError(error)))
            }
        }
        .resume()
        

    
}
}
