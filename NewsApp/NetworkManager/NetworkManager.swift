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
    
    //func obtainPosts(successCompletion: @escaping ([Post]) -> Void, failureCompletion: @escaping (Error) -> Void) {
    func obtainNews(completion: @escaping (ObtainNewsResult) -> Void) {
        guard let url = URL(string: "https://newsapi.org/v2/everything?q=apple&from=2025-05-23&to=2025-05-23&sortBy=popularity&apiKey") else {
            return
        }
        
        //UIApplication.shared.canOpenURL(<#T##url: URL##URL#>)
        
        session.dataTask(with: url) { [weak self] data, response, error in
            
            var result: ObtainNewsResult
            
            // блок который сработает в любом случае при любом оконачании (любом ретурне)
            defer {
                DispatchQueue.main.async {
                    completion(result)
                }
            }
            
            guard let strongSelf = self else {
                //completion([])
                result = .success(articles: [])
                
                return
            }
            
            if let data = data, error == nil {
                
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Raw JSON:\n\(jsonString)")
                }
                
                do {
                    let response = try strongSelf.decoder.decode(NewsResponse.self, from: data)
                    result = .success(articles: response.articles)
                } catch {
                    print("Decode error: \(error.localizedDescription)")
                    result = .failure(error: error)
                }
                
                
                /*
                //TODO: make decoder with try catch (seems like done)
                guard let news = try? strongSelf.decoder.decode([News].self, from: parsData) else {
                    //completion([])
                    result = .success(news: [])
                    return
                }
                
                strongSelf.dataSource = posts
                
                DispatchQueue.main.async {
                    strongSelf.tableView.reloadData()
                }
                 */
                
                //completion(posts)
                
                //result = .success(news: news)
                
            } else {
                //completion([])
                //print("Error: \(error?.localizedDescription ?? "error nil")")
                //failureCompletion(error!)
                
                //result = .failure(error: error!)
                result = .failure(error: error ?? NSError(domain: "Unknown error", code: -1))
            }
            
            
            
        }.resume()
    }
    
}
