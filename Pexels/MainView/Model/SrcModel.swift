//
//  SrcModel.swift
//  Pexels
//
//  Created by Даниил Сивожелезов on 11.06.2024.
//

import Foundation

struct Src: Codable {
    let original, large2X, large, medium: String
    let small, portrait, landscape, tiny: String

    enum CodingKeys: String, CodingKey {
        case original
        case large2X = "large2x"
        case large, medium, small, portrait, landscape, tiny
    }
}
