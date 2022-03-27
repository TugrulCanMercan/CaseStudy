//
//  NetworkManager.swift
//  WheatherCaseStudy
//
//  Created by Tuğrulcan on 24.03.2022.
//

import Foundation


enum NetworkingError:Error{
    
    case UrlError(reason:String)
    case ParamsDecodeError(reason:String)
    case error(String)
    case urlResponseError(URLError)
    case decodeError(Error)
}
enum httpRequestType{
    case bodyRequest
    case queryRequest
    case headerRequest
}


class NetworkManager{
    
    static var shared:NetworkManager = NetworkManager()
    
    private init(){}
  
    

    
    
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
    
//    func getRequest<T:Codable>(url:String,resultDto:T.Type,completion:@escaping (Result<T,networkingError>)->Void)
    
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
}
