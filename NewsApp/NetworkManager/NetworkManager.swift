//
//  NetworkManager.swift
//  NewsApp
//
//  Created by Ivan Petrov on 24.05.2025.
//

import Foundation

enum ObtainPostsResult {
    case success(posts: [Post])
    case failure(error: Error)
}

class NetworkManager {
    
    let sessionConfiguration = URLSessionConfiguration.default
    //sessionConfiguration.timeoutIntervalForRequest
    //sessionConfiguration.timeoutIntervalForResource
    //let session = URLSession(configuration: sessionConfiguration)
    let session = URLSession.shared
    let decoder = JSONDecoder()
    
    //func obtainPosts(successCompletion: @escaping ([Post]) -> Void, failureCompletion: @escaping (Error) -> Void) {
    func obtainPosts(completion: @escaping (ObtainPostsResult) -> Void) {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else {
            return
        }
        
        //UIApplication.shared.canOpenURL(<#T##url: URL##URL#>)
        
        session.dataTask(with: url) { [weak self] data, response, error in
            
            var result: ObtainPostsResult
            
            // блок который сработает в любом случае при любом оконачании (любом ретурне)
            defer {
                DispatchQueue.main.async {
                    completion(result)
                }
            }
            
            guard let strongSelf = self else {
                //completion([])
                result = .success(posts: [])
                
                return
            }
            
            if error == nil, let parsData = data {
                
                //TODO: make decoder with try catch
                guard let posts = try? strongSelf.decoder.decode([Post].self, from: parsData) else {
                    //completion([])
                    result = .success(posts: [])
                    return
                }
                
                /*
                strongSelf.dataSource = posts
                
                DispatchQueue.main.async {
                    strongSelf.tableView.reloadData()
                }
                 */
                
                //completion(posts)
                
                result = .success(posts: posts)
                
            } else {
                //completion([])
                //print("Error: \(error?.localizedDescription ?? "error nil")")
                //failureCompletion(error!)
                
                result = .failure(error: error!)
            }
            
            
            
        }.resume()
    }
    
}
