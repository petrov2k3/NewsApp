//
//  NetworkManager.swift
//  NewsApp
//
//  Created by Ivan Petrov on 24.05.2025.
//

import Foundation

enum ObtainNewsResult {
    case success(articles: [Article])
    case failure(error: Error)
}

class NetworkManager {
    
    let sessionConfiguration = URLSessionConfiguration.default
    //sessionConfiguration.timeoutIntervalForRequest
    //sessionConfiguration.timeoutIntervalForResource
    //let session = URLSession(configuration: sessionConfiguration)
    let session = URLSession.shared
    let decoder = JSONDecoder()
    
    //TODO: make valid date format
    //decoder.dateDecodingStrategy = .iso8601
    
    func obtainNews(completion: @escaping (ObtainNewsResult) -> Void) {
        guard let url = URL(string: "https://newsapi.org/v2/everything?q=apple&from=2025-05-23&to=2025-05-23&sortBy=popularity&apiKey") else {
            return
        }
        
        //UIApplication.shared.canOpenURL(<#T##url: URL##URL#>)
        
        session.dataTask(with: url) { [weak self] data, response, error in
            var result: ObtainNewsResult
            
            defer {
                DispatchQueue.main.async {
                    completion(result)
                }
            }
            
            guard let strongSelf = self else {
                result = .success(articles: [])
                return
            }
            
            if let data = data, error == nil {
                do {
                    let response = try strongSelf.decoder.decode(NewsResponse.self, from: data)
                    result = .success(articles: response.articles)
                } catch {
                    print("Decode error: \(error.localizedDescription)")
                    result = .failure(error: error)
                }
            } else {
                result = .failure(error: error ?? NSError(domain: "Unknown error", code: -1))
            }
        }.resume()
    }
}
