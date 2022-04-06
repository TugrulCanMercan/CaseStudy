//
//  QueryItemBuilder.swift
//  WheatherCaseStudy
//
//  Created by Tuğrul Can MERCAN (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 6.04.2022.
//

import Foundation


@resultBuilder
struct QueryItemBuilder {
    public typealias Expression = URLQueryItem
      public typealias Component = [URLQueryItem]

      public static func buildExpression(_ expression: Expression) -> Component {
          return [expression]
      }

      public static func buildExpression(_ expression: Component) -> Component {
          return expression
      }

      public static func buildExpression(_ expression: Expression?) -> Component {
          guard let expression = expression else { return [] }
          return [expression]
      }

      public static func buildBlock(_ children: Component...) -> Component {
          return children.flatMap { $0 }
      }

      public static func buildBlock(_ component: Component) -> Component {
          return component
      }

      public static func buildOptional(_ children: Component?) -> Component {
          return children ?? []
      }

      public static func buildEither(first child: Component) -> Component {
          return child
      }

      public static func buildEither(second child: Component) -> Component {
          return child
      }

      public static func buildArray(_ components: [Component]) -> Component {
          return components.flatMap { $0 }
      }
}


final class QueryItemsBlock{
    var items:()->[URLQueryItem]?
    
    init(@QueryItemBuilder items:@escaping ()->[URLQueryItem]){
        self.items = items
    }
}

