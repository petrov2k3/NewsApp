//
//  CategoriesPresenter.swift
//  NewsApp
//
//  Created by Ivan Petrov on 01.06.2025.
//

import Foundation

protocol CategoriesPresenter {
    func viewDidLoad()
    func didSelectCategory(at index: Int) -> String
}

final class CategoriesPresenterImpl {
    private weak var view: CategoriesViewController?
    
    private let categories = ["business", "entertainment", "general", "health", "science", "sports", "technology"]
    
    private func loadCategories() {
        self.view?.showCategories(self.categories)
    }
}

//MARK: - Public methods
extension CategoriesPresenterImpl {
    func setupView(_ view: CategoriesViewController) {
        self.view = view
    }
}

//MARK: - CategoriesPresenter
extension CategoriesPresenterImpl: CategoriesPresenter {
    func viewDidLoad() {
        loadCategories()
    }
    
    func didSelectCategory(at index: Int) -> String {
        return categories[index]
    }
}
