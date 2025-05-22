//
//  CategoriesViewController.swift
//  NewsApp
//
//  Created by Ivan Petrov on 21.05.2025.
//

import UIKit

class CategoriesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
    }
    
    private func configureView() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "Категорії"
    }
}
