//
//  HomeViewController.swift
//  NewsApp
//
//  Created by Ivan Petrov on 21.05.2025.
//

import UIKit

// MARK: - Protocol
protocol HomeViewController: AnyObject {
    func showArticles(_ articles: [Article])
    func showError(_ message: String)
}

// MARK: - Implementation
final class HomeViewControllerImpl: UIViewController {
    
    // MARK: - Properties
    private let presenter: HomePresenter
    private let cellIdentifier = "NewsCell"
    private let category: String?
    private var dataSource = [Article]()
    
    // MARK: - UI
    private lazy var searchController: UISearchController = {
        let search = UISearchController(searchResultsController: nil)
        
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Пошук новин"
        
        search.searchBar.delegate = self
        
        return search
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        
        table.register(NewsTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        table.delegate = self
        table.dataSource = self
        
        return table
    }()
    
    //MARK: - Inits
    init(category: String? = nil, presenter: HomePresenter) {
        self.category = category
        self.presenter = presenter
        super.init(nibName: nil, bundle: Bundle.main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        setupTableView()
        presenter.viewDidLoad()
        
        //search
        if category == nil {
            navigationItem.searchController = searchController
            definesPresentationContext = true
        }
    }
    
    //MARK: - Setup UI
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
}

//MARK: - UITableViewDataSource & UITableViewDelegate

extension HomeViewControllerImpl: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? NewsTableViewCell else {
            return UITableViewCell()
        }
        
        let article = dataSource[indexPath.row]
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

//MARK: - UISearchBarDelegate

extension HomeViewControllerImpl: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !query.isEmpty else {
            return
        }
        
        presenter.didSearch(query: query)
        searchBar.resignFirstResponder() // hides keyboard
    }
}

//MARK: - HomeViewController
extension HomeViewControllerImpl: HomeViewController {
    func showArticles(_ articles: [Article]) {
        self.dataSource = articles
        tableView.reloadData()
    }
    
    func showError(_ message: String) {
        print("Error: ", message)
        // maybe show alert
    }
}
