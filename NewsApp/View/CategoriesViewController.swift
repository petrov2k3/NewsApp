//
//  CategoriesViewController.swift
//  NewsApp
//
//  Created by Ivan Petrov on 21.05.2025.
//

import UIKit

// MARK: - Protocol
protocol CategoriesViewController: AnyObject {
    func showCategories(_ categories: [String])
    func showError(_ message: String)
}

// MARK: - Implementation
final class CategoriesViewControllerImpl: UIViewController {
    
    // MARK: - Properties
    private let presenter: CategoriesPresenter
    private var categories: [String] = []
    private let cellIdentifier = "CategoryCell"
    
    // MARK: - UI
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        
        table.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        table.delegate = self
        table.dataSource = self
        
        return table
    }()
    
    // MARK: - Inits
    init(presenter: CategoriesPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: Bundle.main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.viewDidLoad()
        
        configureView()
        setupTableView()
    }
    
    // MARK: - Setup UI
    private func configureView() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "Категорії"
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

extension CategoriesViewControllerImpl: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let category = categories[indexPath.row]
        
        cell.textLabel?.text = category.capitalized
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCategory = presenter.didSelectCategory(at: indexPath.row)
        let homeVC = HomeViewController(category: selectedCategory)
         
        navigationController?.pushViewController(homeVC, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: - CategoriesViewController

extension CategoriesViewControllerImpl: CategoriesViewController {
    func showCategories(_ categories: [String]) {
        self.categories = categories
        tableView.reloadData()
    }
    
    func showError(_ message: String) {
        print("Error: ", message)
        // maybe show alert
    }
}
