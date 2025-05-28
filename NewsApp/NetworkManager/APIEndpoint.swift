//
//  APIEndpoint.swift
//  NewsApp
//
//  Created by Ivan Petrov on 25.05.2025.
//

import Foundation

enum APIEndpoint {
    case newsList(query: String)
    case topHeadlines(category: String)
    
    var urlRequest: URLRequest {
        switch self {
        case .newsList(let query):
            var components = URLComponents(string: "https://newsapi.org/v2/everything")!
            components.queryItems = [
                URLQueryItem(name: "q", value: query),
                URLQueryItem(name: "apiKey", value: "")
            ]
            let url = components.url!
            return URLRequest(url: url)
            
        case .topHeadlines(category: let category):
            var components = URLComponents(string: "https://newsapi.org/v2/top-headlines")!
            components.queryItems = [
                URLQueryItem(name: "country", value: "us"),
                URLQueryItem(name: "category", value: category),
                URLQueryItem(name: "apiKey", value: "")
            ]
            let url = components.url!
            return URLRequest(url: url)
        }
    }
}


//TODO: api key within secure.plist ?
//let apiKey = Bundle.main.infoDictionary?["NewsAPIKey"] as? String ?? ""
