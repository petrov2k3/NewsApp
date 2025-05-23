//
//  HomeViewController.swift
//  NewsApp
//
//  Created by Ivan Petrov on 21.05.2025.
//

import UIKit

class HomeViewController: UIViewController {
    
    private let cellIdentifier = "NewsCell"
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        // subscribe to protocols; delegate and pass information to this controller (self)
        table.delegate = self
        table.dataSource = self
        
        table.translatesAutoresizingMaskIntoConstraints = false
        
        return table
    }()
    
    private let newsArray = [
        "Title 1", "Title 2", "Title 3", "Title 4", "Title 5",
        "Title 6", "Title 7", "Title 8", "Title 9"
    ]
    
    var dataSource = [Post]()
    
    let sessionConfiguration = URLSessionConfiguration.default
    //sessionConfiguration.timeoutIntervalForRequest
    //sessionConfiguration.timeoutIntervalForResource
    //let session = URLSession(configuration: sessionConfiguration)
    let session = URLSession.shared
    let decoder = JSONDecoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        setupTableView()
        
        obtainPosts()
        
    }
    
    //MARK: - Network
    //TODO: design it more architecturally correct
    
    func obtainPosts() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else {
            return
        }
        
        //UIApplication.shared.canOpenURL(<#T##url: URL##URL#>)
        
        session.dataTask(with: url) { [weak self] data, response, error in
            
            guard let strongSelf = self else { return }
            
            if error == nil, let parsData = data {
                
                //TODO: make decoder with try catch
                guard let posts = try? strongSelf.decoder.decode([Post].self, from: parsData) else {
                    return
                }
                
                //print("Posts: \(posts?.count)")
                
                strongSelf.dataSource = posts
                
                DispatchQueue.main.async {
                    strongSelf.tableView.reloadData()
                }
                
            } else {
                print("Error: \(error?.localizedDescription ?? "error nil")")
            }
            
        }.resume()
    }
    
    private func configureView() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "Головна"
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

//MARK: - UITableViewDataSource & UITableViewDelegate

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return newsArray.count
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        let post = dataSource[indexPath.row]
        
        var config = cell.defaultContentConfiguration()
        //config.text = newsArray[indexPath.row]
        //config.secondaryText = "Description \(indexPath.row + 1)"
        config.text = post.title
        config.secondaryText = post.body
        cell.contentConfiguration = config
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("Selected news: \(newsArray[indexPath.row])")
        print("Selected post: \(dataSource[indexPath.row])")
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
