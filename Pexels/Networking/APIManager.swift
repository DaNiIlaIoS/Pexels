//
//  APIManager.swift
//  Pexels
//
//  Created by Даниил Сивожелезов on 10.06.2024.
//

import Foundation
import UIKit

final class APIManager {
    // MARK: - Properties
    private static let endpoint = "https://api.pexels.com/v1/search"
    private static let apiKey = "w4pGwK3YPe99YEpYL8UFCNBMt8QheaPMJaxHCbhbJE9iiNHeTSzhNMAR"
    
    // MARK: - Create url path and make request
    static func search(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else {
            print("Search bar text is nil")
            return
        }
        guard !searchText.isEmpty else {
            print("Search bar is empty")
            return
        }
        
        guard var urlComponents = URLComponents(string: endpoint) else {
            print("Couldn't create URLComponents instance from endpoint - \(endpoint)")
            return
        }
        
        let parameters = [URLQueryItem(name: "query", value: searchText),
                          URLQueryItem(name: "per_page", value: "10")]
        urlComponents.queryItems = parameters
        
        guard let url = urlComponents.url else {
            print("URL is nil")
            return
        }
        
        var urlRequest = URLRequest(url: url)
//        urlRequest.httpMethod = "GET"
        
        urlRequest.addValue(apiKey, forHTTPHeaderField: "Authorization")
//        print(urlRequest)
        
        let urlSession = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            searchPhotosHandler(data: data, response: response, error: error)
        }
        
        urlSession.resume()
    }
    
    // MARK: - Handle Response
    private static func searchPhotosHandler(data: Data?, response: URLResponse?, error: Error?) {
        print("Method searchPhotosHandler was called")
    
    }
}
