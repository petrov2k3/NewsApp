//
//  CategoriesViewController.swift
//  NewsApp
//
//  Created by Ivan Petrov on 21.05.2025.
//

import UIKit

class CategoriesViewController: UIViewController {
    
    private let presenter: CategoriesPresenter
    
    enum Mode {
        case list
        case news(category: String)
    }
    
    private let mode: Mode
    
    /*
    init(mode: Mode = .list) {
        self.mode = mode
        super.init(nibName: nil, bundle: nil)
        
        self.presenter = CategoriesPresenter(view: self)
    }
     */
    
    init(mode: Mode = .list, presenter: CategoriesPresenter? = nil) {
        self.mode = mode
        self.presenter = presenter ?? CategoriesPresenter(view: nil, mode: mode)
        super.init(nibName: nil, bundle: nil)
        self.presenter.view = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var categories: [String] = []
    private let cellIdentifier = "CategoryCell"
    
    private var dataSource = [Article]()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        
        table.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        table.register(NewsTableViewCell.self, forCellReuseIdentifier: "NewsByCategoryCell")
        
        table.delegate = self
        table.dataSource = self
        
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        setupTableView()
        presenter.viewDidLoad()
        
        /*
        switch mode {
        case .list:
            //print("Show categories list")
            break
        case .news(let category):
            //print("Loading news by category: \(category)")
            navigationItem.title = category.capitalized
            //obtainNews(for: category)
        }
         */
    }
    
    private func configureView() {
        view.backgroundColor = .systemBackground
        //navigationItem.title = "Категорії"
        navigationItem.title = {
            switch mode {
            case .list:
                return "Категорії"
            case .news(let category):
                return category.capitalized
            }
        }()
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
    
    // moved to its presenter
    /*
    private func obtainNews(for category: String) {
        NetworkManager.shared.request(.topHeadlines(category: category)) { [weak self] (result: Result<NewsResponse, APIError>) in
            switch result {
            case .success(let response):
                self?.dataSource = response.articles
                self?.tableView.reloadData()
            case .failure(let error):
                print("Error loading news for category \(category):", error)
            }
        }
    }
    */
    
}

//MARK: - UITableViewDataSource & UITableViewDelegate

extension CategoriesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch mode {
        case .list:
            return categories.count
        case .news:
            return dataSource.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch mode {
        case .list:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
            let category = categories[indexPath.row]
            cell.textLabel?.text = category.capitalized
            cell.accessoryType = .disclosureIndicator
            return cell
            
        case .news:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsByCategoryCell", for: indexPath) as? NewsTableViewCell else {
                return UITableViewCell()
            }
            
            let article = dataSource[indexPath.row]
            cell.configure(with: article)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch mode {
        case .list:
            return 50.0
        case .news:
            return 110.0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch mode {
        case .list:
            
            /*
            let selectedCategory = categories[indexPath.row]
            //print("You selected category: \(selectedCategory)")
            let newsByCategoryVC = CategoriesViewController(mode: .news(category: selectedCategory))
            navigationController?.pushViewController(newsByCategoryVC, animated: true)
             */
            
            let selectedCategory = presenter.didSelectCategory(at: indexPath.row)
            let homeVC = HomeViewController(category: selectedCategory)
            
            /*
            let newsByCategoryVC = CategoriesViewController(
                mode: .news(category: selectedCategory),
                presenter: CategoriesPresenter(view: nil, mode: .news(category: selectedCategory))
            )
            
            newsByCategoryVC.presenter.view = newsByCategoryVC
             */
             
            navigationController?.pushViewController(homeVC, animated: true)
            
            
        case .news:
            print("Selected article: \(dataSource[indexPath.row])")
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: - CategoriesViewProtocol

extension CategoriesViewController: CategoriesViewProtocol {
    func showCategories(_ categories: [String]) {
        self.categories = categories
        tableView.reloadData()
    }
    
    func showNews(_ articles: [Article]) {
        self.dataSource = articles
        tableView.reloadData()
    }
    
    func showLoading(_ isLoading: Bool) {
        // мб поставить индикатор загрузки; пока просто принт
        print(isLoading ? "Loading..." : "Done")
    }
    
    func showError(_ message: String) {
        print("Error: ", message)
        // мб показывать алерт
    }
    
    
}
