//
//  String+Ex.swift
//  Pexels
//
//  Created by Даниил Сивожелезов on 29.05.2024.
//

import Foundation

extension String {
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
    
    static let appOrange = "appOrange"
    static let descriptionColor = "descriptionColor"
    static let titleColor = "titleColor"
}
