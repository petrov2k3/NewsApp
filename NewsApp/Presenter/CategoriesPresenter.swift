//
//  CategoriesPresenter.swift
//  NewsApp
//
//  Created by Ivan Petrov on 01.06.2025.
//

import Foundation

protocol CategoriesViewProtocol: AnyObject {
    func showCategories(_ categories: [String])
    func showNews(_ articles: [Article])
    func showLoading(_ isLoading: Bool)
    func showError(_ message: String)
}

final class CategoriesPresenter {
    
    // MARK: - Properties
    
    weak var view: CategoriesViewProtocol?
    private let networkManager: NetworkManager
    private let mode: CategoriesViewController.Mode
    
    private let categories = ["business", "entertainment", "general", "health", "science", "sports", "technology"]
    
    // MARK: - Init
    
    init(view: CategoriesViewProtocol? = nil, networkManager: NetworkManager = .shared, mode: CategoriesViewController.Mode) {
        self.view = view
        self.networkManager = networkManager
        self.mode = mode
    }
    
    // MARK: - Public methods
    
    func viewDidLoad() {
        switch mode {
        case .list:
            loadCategories()
        case .news(let category):
            loadNews(for: category)
        }
    }
    
    func didSelectCategory(at index: Int) -> String {
        return categories[index]
    }
    
    // MARK: - Private methods
    
    private func loadCategories() {
        view?.showLoading(true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            guard let self = self else { return }
            self.view?.showLoading(false)
            self.view?.showCategories(self.categories)
        }
    }
    
    /*
    func loadCategories() {
        view?.showLoading(true)
        // симулируем задержку для примера
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            self?.view?.showLoading(false)
            self?.view?.showCategories(self?.categories ?? [])
        }
    }
     */
    
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
}
