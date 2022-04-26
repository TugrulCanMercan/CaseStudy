//
//  NetworkMockManager.swift
//  WheatherCaseStudy
//
//  Created by Tuğrul Can MERCAN (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 7.04.2022.
//

import Foundation
import Combine



//class NetworkMockManager:NSObject{
//    
//    
////    static var shared: NetworkManagerProtocol = NetworkMockManager()
//    
//    
//    
//    
//    
////    func getRequestCombine(endPointUrl: String) -> AnyPublisher<Data, Error> {
////        let url = URL(string: endPointUrl)
////        guard let url = url else {
////            return AnyPublisher(Fail<Data,Error>(error: URLError(.badURL)))
////        }
////
////        return Just(Data).eraseToAnyPublisher()
////    }
////
//    func post<T>(endpointUrl: String, params: T) -> AnyPublisher<Data, Error> where T : Decodable, T : Encodable {
//        let encoder = JSONEncoder()
//        
//        encoder.outputFormatting = .prettyPrinted
//        let data = try? encoder.encode(params)
//        guard let url = URL(string: endpointUrl) else {
//            return AnyPublisher(Fail<Data,Error>(error: URLError(.badURL)))
//        }
//        var request = URLRequest(url: url)
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpMethod = "POST"
//        request.httpBody = data
//        
//        
//        return URLSession.shared.dataTaskPublisher(for: request)
//            .tryMap { (data,response) -> Data in
//                guard let response = response as? HTTPURLResponse, response.statusCode >= 200 && response.statusCode < 300 else{
//                    throw URLError(.badServerResponse)
//                }
//                return data
//            }
//            .eraseToAnyPublisher()
//    }
//    
//  
//    
//}
