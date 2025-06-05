//
//  HomePresenter.swift
//  NewsApp
//
//  Created by Ivan Petrov on 05.06.2025.
//

import Foundation

protocol HomePresenter {
    func viewDidLoad()
    func didSearch(query: String)
}

final class HomePresenterImpl {
    
    //MARK: - Properties
    private weak var view: HomeViewController?
    private let networkManager = NetworkManager.shared
    private let category: String?
    
    //MARK: - Init
    init(category: String?) {
        self.category = category
    }
    
    //MARK: - Private methods
    private func obtainNews() {
        if let category = category {
            networkManager.request(.topHeadlines(category: category)) { [weak self] (result: Result<NewsResponse, APIError>) in
                guard let self else { return }
                
                switch result {
                case .success(let response):
                    self.view?.showArticles(response.articles)
                case .failure(let error):
                    self.view?.showError("Error loading news by category: \(error.localizedDescription)")
                }
            }
        } else {
            networkManager.request(.newsList(query: "apple")) { [weak self] (result: Result<NewsResponse, APIError>) in
                guard let self else { return }
                
                switch result {
                case .success(let response):
                    self.view?.showArticles(response.articles)
                case .failure(let error):
                    self.view?.showError("Error loading general news: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func searchNews(query: String) {
        networkManager.request(.newsList(query: query)) { [weak self] (result: Result<NewsResponse, APIError>) in
            guard let self else { return }
            
            switch result {
            case .success(let response):
                self.view?.showArticles(response.articles)
            case .failure(let error):
                self.view?.showError("Search API error: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - Public methods
extension HomePresenterImpl {
    func setupView(_ view: HomeViewController) {
        self.view = view
    }
}

// MARK: - HomePresenter
extension HomePresenterImpl: HomePresenter {
    func viewDidLoad() {
        obtainNews()
    }
    
    func didSearch(query: String) {
        searchNews(query: query)
    }
    
    
}

