//
//  OnboardingCollectionViewCell.swift
//  Pexels
//
//  Created by Даниил Сивожелезов on 20.05.2024.
//

import UIKit

class OnboardingCollectionViewCell: UICollectionViewCell {
    
    static let identifier: String = "OnboardingCollectionViewCell"
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var inneStackView: UIStackView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setup(onboardingModel: OnboardingModel) {
        imageView.image = UIImage(named: onboardingModel.imageName)
        titleLabel.text = onboardingModel.title
        subtitleLabel.text = onboardingModel.subtitle
    }
}
