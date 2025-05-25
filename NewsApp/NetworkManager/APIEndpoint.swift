//
//  APIEndpoint.swift
//  NewsApp
//
//  Created by Ivan Petrov on 25.05.2025.
//

import Foundation

enum APIEndpoint {
    case newsList
    
    var urlRequest: URLRequest {
        switch self {
        case .newsList:
            var components = URLComponents(string: "https://newsapi.org/v2/everything")!
            components.queryItems = [
                URLQueryItem(name: "q", value: "apple"),
                //TODO: api key within secure plist ?
                URLQueryItem(name: "apiKey", value: "")
            ]
            let url = components.url!
            return URLRequest(url: url)
        }
    }
}
