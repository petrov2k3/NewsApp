//
//  CategoriesViewController.swift
//  NewsApp
//
//  Created by Ivan Petrov on 21.05.2025.
//

import UIKit

class CategoriesViewController: UIViewController {
    
    private let presenter: CategoriesPresenter
    private var categories: [String] = []
    private let cellIdentifier = "CategoryCell"
    
    init(presenter: CategoriesPresenter? = nil) {
        self.presenter = presenter ?? CategoriesPresenter(view: nil)
        super.init(nibName: nil, bundle: nil)
        self.presenter.view = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    }
    
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

extension CategoriesViewController: UITableViewDataSource, UITableViewDelegate {
    
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
        /*
        let selectedCategory = categories[indexPath.row]
        //print("You selected category: \(selectedCategory)")
        let newsByCategoryVC = CategoriesViewController(mode: .news(category: selectedCategory))
        navigationController?.pushViewController(newsByCategoryVC, animated: true)
         */
        
        let selectedCategory = presenter.didSelectCategory(at: indexPath.row)
        print("You selected category: \(selectedCategory)")
        let homeVC = HomeViewController(category: selectedCategory)
        
        /*
        let newsByCategoryVC = CategoriesViewController(
            mode: .news(category: selectedCategory),
            presenter: CategoriesPresenter(view: nil, mode: .news(category: selectedCategory))
        )
        
        newsByCategoryVC.presenter.view = newsByCategoryVC
         */
         
        navigationController?.pushViewController(homeVC, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: - CategoriesViewProtocol

extension CategoriesViewController: CategoriesViewProtocol {
    func showCategories(_ categories: [String]) {
        self.categories = categories
        tableView.reloadData()
    }
    
    func showError(_ message: String) {
        print("Error: ", message)
        // maybe show alert
    }
}
