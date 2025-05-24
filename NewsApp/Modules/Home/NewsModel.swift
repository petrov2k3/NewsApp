//
//  NewsModel.swift
//  NewsApp
//
//  Created by Ivan Petrov on 24.05.2025.
//

import Foundation

struct NewsResponse: Codable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}

struct Article: Codable {
    let source: Source
    let author: String?
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    //TODO: make valid date format
    //let publishedAt: Date
    let publishedAt: String
    let content: String?
}

struct Source: Codable {
    let id: String?
    let name: String
}
