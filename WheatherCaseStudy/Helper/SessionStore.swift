//
//  SessionStore.swift
//  WheatherCaseStudy
//
//  Created by Tuğrul Can MERCAN (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 5.04.2022.
//

import Foundation


enum SessionKey:Hashable{
    case weatherApiKey
}



public class VKFSession {
    
    public static let shared = VKFSession()
    private let processQueue = DispatchQueue(label: "VKFSessionDispatchQueue", attributes: .concurrent)
    private var dataKeeper: Dictionary<SessionKey, Any>
    
    private init() {
        dataKeeper = Dictionary<SessionKey, Any>()
//        dataKeeper[.internetPasswordRequired] = true
    }
    
    func store<T>(with key: SessionKey, value: T) {
        processQueue.async(flags: .barrier) { [weak self] in
            self?.dataKeeper[key] = value
        }
    }
    
    func retrieve<T>(with key: SessionKey) -> T? {
        var value: T?
        processQueue.sync { [weak self] in
            value = self?.dataKeeper[key] as? T
        }
        return value
    }
    
    func remove(key: SessionKey) {
        processQueue.async(flags: .barrier) { [weak self] in
            self?.dataKeeper.removeValue(forKey: key)
        }
    }
}
