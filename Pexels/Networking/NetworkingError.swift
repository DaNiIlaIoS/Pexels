//
//  NetworkingError.swift
//  Pexels
//
//  Created by Даниил Сивожелезов on 14.06.2024.
//

import Foundation

enum NetworkingError: Error {
    case networkingError(_ error: Error)
    case unknownError
}
