//
//  Extension-Mirror.swift
//  WheatherCaseStudy
//
//  Created by Tuğrul Can MERCAN (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 30.03.2022.
//

import Foundation



extension Mirror {
    func firstChild<T>(named name:String)->T?{
        children.compactMap{
            
            guard let value = $0.value as? T else {return nil }
            
            return $0.label == name ? value : nil
        }.first
    }
}
