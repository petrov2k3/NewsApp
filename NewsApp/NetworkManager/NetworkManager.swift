//
//  NetworkManager.swift
//  NewsApp
//
//  Created by Ivan Petrov on 24.05.2025.
//

import Foundation

final class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    func request<T: Decodable>(
        _ endpoint: APIEndpoint,
        completion: @escaping (Result<T, APIError>) -> Void
    ) {
        let request = endpoint.urlRequest
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            // network error
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(.networkError(error)))
                }
                return
            }
            
            // invalid response or data
            guard let httpResponse = response as? HTTPURLResponse,
                  200..<300 ~= httpResponse.statusCode,
                  let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(.invalidResponse))
                }
                return
            }
            
            // decode JSON
            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decoded))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(.decodingError))
                }
            }
            
        }.resume()
    }
}

/*
enum ObtainNewsResult {
    case success(articles: [Article])
    case failure(error: Error)
}
 */

/*
final class NetworkManager {
    
    static let shared = NetworkManager()
    private init() {}
    
    
    
    let sessionConfiguration = URLSessionConfiguration.default
    //sessionConfiguration.timeoutIntervalForRequest
    //sessionConfiguration.timeoutIntervalForResource
    //let session = URLSession(configuration: sessionConfiguration)
    let session = URLSession.shared
    let decoder = JSONDecoder()
    
    //TODO: make valid date format
    //decoder.dateDecodingStrategy = .iso8601
    
    func obtainNews(completion: @escaping (ObtainNewsResult) -> Void) {
        guard let url = URL(string: "https://newsapi.org/v2/everything?q=apple&from=2025-05-23&to=2025-05-23&sortBy=popularity&apiKey=9dc6d99a7e52447da5285d3ea657a5e7") else {
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
*/
