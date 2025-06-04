//
//  HomeViewController.swift
//  NewsApp
//
//  Created by Ivan Petrov on 21.05.2025.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - Properties
    
    private let cellIdentifier = "NewsCell"
    private let category: String?
    private var dataSource = [Article]()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        
        table.register(NewsTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        table.delegate = self
        table.dataSource = self
        
        return table
    }()
    
    //let networkManager = NetworkManager()
    
    //MARK: - Inits
    
    init(category: String? = nil) {
        self.category = category
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        setupTableView()
        obtainNews()
        
        //search
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Пошук новин"
        //searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    //MARK: - Methods
    
    private func configureView() {
        view.backgroundColor = .systemBackground
        navigationItem.title = category?.capitalized ?? "Головна"
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        
        //tableView.rowHeight = UITableView.automaticDimension
        //tableView.estimatedRowHeight = 110
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    /*
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
     */
    
    private func obtainNews() {
        if let category = category {
            NetworkManager.shared.request(.topHeadlines(category: category)) { [weak self] (result: Result<NewsResponse, APIError>) in
                switch result {
                case .success(let response):
                    self?.dataSource = response.articles
                    self?.tableView.reloadData()
                case .failure(let error):
                    print("Error loading news by category:", error)
                }
            }
        } else {
            NetworkManager.shared.request(.newsList(query: "apple")) { [weak self] (result: Result<NewsResponse, APIError>) in
                switch result {
                case .success(let response):
                    self?.dataSource = response.articles
                    self?.tableView.reloadData()
                case .failure(let error):
                    print("Error loading general news:", error)
                }
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
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? NewsTableViewCell else {
            return UITableViewCell()
        }
        
        let article = dataSource[indexPath.row]
        
        /*
        var config = cell.defaultContentConfiguration()
        config.text = article.title
        config.secondaryText = article.description
        cell.contentConfiguration = config
         */
        
        cell.configure(with: article)
        
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

//MARK: - UISearchResultsUpdating

extension HomeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !query.isEmpty else {
            return
        }
        
        NetworkManager.shared.request(.newsList(query: query)) { [weak self] (result: Result<NewsResponse, APIError>) in
            switch result {
            case .success(let response):
                self?.dataSource = response.articles
                self?.tableView.reloadData()
            case .failure(let error):
                print("Search API error:", error)
            }
        }
        
        searchBar.resignFirstResponder() // hides keyboard
    }
}

/*
extension HomeViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            dataSource = []
            tableView.reloadData()
            return
        }
        
        NetworkManager.shared.request(.newsList(query: query)) { [weak self] (result: Result<NewsResponse, APIError>) in
            switch result {
            case .success(let response):
                self?.dataSource = response.articles
                self?.tableView.reloadData()
            case .failure(let error):
                print("Search API error:", error)
            }
        }
    }
    
    /*
     // делал с фильтрацией начального запроса
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text?.lowercased(), !query.isEmpty else {
            filteredArticles = []
            tableView.reloadData()
            return
        }

        filteredArticles = allArticles.filter {
            $0.title.lowercased().contains(query) ||
            ($0.description?.lowercased().contains(query) ?? false)
        }

        tableView.reloadData()
    }
    */
}
*/
