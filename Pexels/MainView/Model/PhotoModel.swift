//
//  PhotoModel.swift
//  Pexels
//
//  Created by Даниил Сивожелезов on 11.06.2024.
//

import Foundation

struct Photo: Codable {
    let id, width, height: Int
    let url: String
    let photographer: String
    let photographerURL: String
    let photographerID: Int
    let avgColor: String
    let src: Src
    let liked: Bool
    let alt: String

    enum CodingKeys: String, CodingKey {
        case id, width, height, url, photographer
        case photographerURL = "photographer_url"
        case photographerID = "photographer_id"
        case avgColor = "avg_color"
        case src, liked, alt
    }
}

// MARK: - Src

