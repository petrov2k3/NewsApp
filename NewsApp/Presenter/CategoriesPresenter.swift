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
    
    /*
    // will move to HomePresenter later i think
    private func loadNews(for category: String) {
        view?.showLoading(true)
        
        //TODO: think where to move this request (HomePresenter maybe idk)
        networkManager.request(.topHeadlines(category: category)) { [weak self] (result: Result<NewsResponse, APIError>) in
            guard let self = self else { return }
            
            self.view?.showLoading(false)
            
            switch result {
            case .success(let response):
                self.view?.showNews(response.articles)
            case .failure(let error):
                self.view?.showError("Error loading news for category \(category): \(error.localizedDescription)")
            }
        }
    }
    */
}

// MARK: - Public methods
extension CategoriesPresenterImpl {
    func setupView(_ view: CategoriesViewController) {
        self.view = view
    }
}

// MARK: - CategoriesPresenter
extension CategoriesPresenterImpl: CategoriesPresenter {
    func viewDidLoad() {
        loadCategories()
    }
    
    func didSelectCategory(at index: Int) -> String {
        return categories[index]
    }
}
