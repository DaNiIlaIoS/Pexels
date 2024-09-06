//
//  OnboardingModel.swift
//  Pexels
//
//  Created by Даниил Сивожелезов on 20.05.2024.
//

import Foundation

struct OnboardingModel {
    let imageName: String
    let title: String
    let subtitle: String
    
    static func generatePages() -> [OnboardingModel] {
        [OnboardingModel(imageName: "onboarding1",
                         title: "Access Anywhere",
                         subtitle: "The video call feature can be accessed from anywhere in your house to help you."),
         OnboardingModel(imageName: "onboarding2",
                         title: "Don’t Feel Alone",
                         subtitle: "Nobody likes to be alone and the built-in group video call feature helps you connect."),
         OnboardingModel(imageName: "onboarding3",
                         title: "Happiness",
                         subtitle: "While working the app reminds you to smile, laugh, walk and talk with those who matters.")]
    }
}
