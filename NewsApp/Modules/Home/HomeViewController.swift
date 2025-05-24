//
//  HomeViewController.swift
//  NewsApp
//
//  Created by Ivan Petrov on 21.05.2025.
//

import UIKit

class HomeViewController: UIViewController {
    
    private let cellIdentifier = "NewsCell"
    private var dataSource = [Article]()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        
        table.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        table.delegate = self
        table.dataSource = self
        
        return table
    }()
    
    let networkManager = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        setupTableView()
        obtainNews()
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
    
    private func obtainNews() {
        networkManager.obtainNews { [weak self] result in
            switch result {
            case .success(let articles):
                self?.dataSource = articles
                
                DispatchQueue.main.async { // code duplication?
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print("News loading error: \(error.localizedDescription)")
            }
        }
    }
}

//MARK: - UITableViewDataSource & UITableViewDelegate

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        let article = dataSource[indexPath.row]
        
        var config = cell.defaultContentConfiguration()
        config.text = article.title
        config.secondaryText = article.description
        cell.contentConfiguration = config
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected article: \(dataSource[indexPath.row])")
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
