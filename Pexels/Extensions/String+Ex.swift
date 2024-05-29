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
}
