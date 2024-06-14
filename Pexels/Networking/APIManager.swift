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
    static let shared = APIManager()
    
    private init() { }
    
    private let endpoint = "https://api.pexels.com/v1/search"
    private let apiKey = "w4pGwK3YPe99YEpYL8UFCNBMt8QheaPMJaxHCbhbJE9iiNHeTSzhNMAR"
    
    // MARK: - Create url path and make request
    func search(_ searchBar: UISearchBar, completion: @escaping (Result<[PhotoModel], Error>) -> Void) {
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
                          URLQueryItem(name: "per_page", value: "20")]
        urlComponents.queryItems = parameters
        
        guard let url = urlComponents.url else {
            print("URL is nil")
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        urlRequest.addValue(apiKey, forHTTPHeaderField: "Authorization")
        //        print(urlRequest)
        
        let urlSession = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            self.searchPhotosHandler(data: data, response: response, error: error, completion: completion)
        }
        
        urlSession.resume()
    }
    func getImage(url: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: url) else {
            print("Could't create an url")
            return
        }
        let session = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                completion(.success(data))
            }
            if let error = error {
                completion(.failure(error))
            }
        }
        session.resume()
    }
    
    // MARK: - Handle Response
    private func searchPhotosHandler(data: Data?,
                                     response: URLResponse?,
                                     error: Error?,
                                     completion: (Result<[PhotoModel], Error>) -> Void) {
        if let error = error {
            completion(.failure(NetworkingError.networkingError(error)))
        } else if let data = data {
            do {
                //                let jsonObject = try JSONSerialization.jsonObject(with: data)
                //                print(jsonObject)
                let model = try JSONDecoder().decode(SearchPhotosModel.self, from: data)
                completion(.success(model.photos))
                print(model)
                
            } catch {
                print(error.localizedDescription)
            }
        } else {
            completion(.failure(NetworkingError.unknownError))
        }
        
        if let urlResponse = response, let httpResponse = urlResponse as? HTTPURLResponse {
            print("HTTP status: \(httpResponse.statusCode)")
        }
    }
}


