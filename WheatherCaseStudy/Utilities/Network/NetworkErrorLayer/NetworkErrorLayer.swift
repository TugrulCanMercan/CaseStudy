//
//  NetworkErrorLayer.swift
//  WheatherCaseStudy
//
//  Created by Tuğrul Can MERCAN (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 6.04.2022.
//

import Foundation

enum NetworkingError:Error{
    
    case UrlError(reason:String)
    case ParamsDecodeError(reason:String)
    case error(String)
    case urlResponseError(URLError)
    case decodeError(Error)
}
