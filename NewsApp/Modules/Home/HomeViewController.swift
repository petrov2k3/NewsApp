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
    
    var dataSource = [Article]()
    
    let networkManager = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        setupTableView()
        
        //obtainPosts()
        
        /*
        networkManager.obtainPosts { posts in
            <#code#>
        } failureCompletion: { error in
            <#code#>
        }
         */

        /*
        networkManager.obtainPosts { [weak self] result in
            switch result {
            case .success(let news):
                self?.dataSource = news
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
        */
        
        networkManager.obtainNews { [weak self] result in
            switch result {
            case .success(let articles):
                self?.dataSource = articles
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print("News loading error: \(error.localizedDescription)")
            }
        }
    }
    
    //MARK: - Network
    //TODO: design it more architecturally correct
    
    
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
        
        let article = dataSource[indexPath.row]
        
        var config = cell.defaultContentConfiguration()
        //config.text = newsArray[indexPath.row]
        //config.secondaryText = "Description \(indexPath.row + 1)"
        config.text = article.title
        config.secondaryText = article.description
        cell.contentConfiguration = config
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("Selected news: \(newsArray[indexPath.row])")
        print("Selected post: \(dataSource[indexPath.row])")
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
