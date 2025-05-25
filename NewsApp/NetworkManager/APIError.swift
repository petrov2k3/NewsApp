//
//  APIError.swift
//  NewsApp
//
//  Created by Ivan Petrov on 25.05.2025.
//

import Foundation

enum APIError: Error {
    case invalidResponse
    case decodingError
    case networkError(Error)
}
