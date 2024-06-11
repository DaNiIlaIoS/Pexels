//
//  SearchPhotosModel.swift
//  Pexels
//
//  Created by Даниил Сивожелезов on 11.06.2024.
//

import Foundation

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let searchPhotosModel = try? JSONDecoder().decode(SearchPhotosModel.self, from: jsonData)

// MARK: - SearchPhotosModel
struct SearchPhotosModel: Codable {
    let totalResults, page, perPage: Int
    let photos: [Photo]
    let nextPage: String

    enum CodingKeys: String, CodingKey {
        case totalResults = "total_results"
        case page
        case perPage = "per_page"
        case photos
        case nextPage = "next_page"
    }
}
