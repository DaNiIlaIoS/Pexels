//
//  OnboardingCollectionViewCell.swift
//  Pexels
//
//  Created by Даниил Сивожелезов on 20.05.2024.
//

import UIKit
import SnapKit

class OnboardingCollectionViewCell: UICollectionViewCell {
    
    static let identifier: String = "OnboardingCollectionViewCell"
    
    private lazy var mainStackView: UIStackView = {
       let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .center
        stack.spacing = 32
        stack.addArrangedSubview(imageView)
        stack.addArrangedSubview(labelsStackView)
        return stack
    }()
    
    private lazy var labelsStackView: UIStackView = {
       let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 16
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(descriptionLabel)
        return stack
    }()
    
    private lazy var imageView: UIImageView = {
       let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        return image
    }()
    
    private lazy var titleLabel: UILabel = {
       let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textColor = UIColor(named: String.titleColor)
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
       let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = UIColor(named: String.descriptionColor)
        return label
    }()
    
    func configure(item: OnboardingModel) {
        setupUI()
        imageView.image = UIImage(named: item.imageName)
        titleLabel.text = item.title
        descriptionLabel.text = item.subtitle
    }
    
    func setupUI() {
        addSubview(mainStackView)
        setupConstraints()
    }
    
    func setupConstraints() {
        mainStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview().multipliedBy(0.7)
            make.leading.trailing.equalToSuperview().inset(50)
        }
    }
}
