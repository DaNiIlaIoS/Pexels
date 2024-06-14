//
//  SearchPhotosModel.swift
//  Pexels
//
//  Created by Даниил Сивожелезов on 11.06.2024.
//

import Foundation

struct SearchPhotosModel: Codable {
    let totalResults, page, perPage: Int
    let photos: [PhotoModel]
    let nextPage: String

    enum CodingKeys: String, CodingKey {
        case totalResults = "total_results"
        case page
        case perPage = "per_page"
        case photos
        case nextPage = "next_page"
    }
}
