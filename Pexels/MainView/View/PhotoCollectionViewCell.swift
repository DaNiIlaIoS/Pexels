//
//  PhotoCollectionViewCell.swift
//  Pexels
//
//  Created by Даниил Сивожелезов on 11.06.2024.
//

import UIKit
import SnapKit

final class PhotoCollectionViewCell: UICollectionViewCell {
    
    // MARK: - GUI Variables
    private lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "image")
        image.contentMode = .scaleAspectFill
        image.layer.masksToBounds = true
        return image
    }()
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = UIImage(named: "image")
    }
    
    // MARK: - Methods
    private func setupUI() {
        addSubview(imageView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.top.trailing.bottom.leading.equalToSuperview()
        }
    }
    func loadImage(witch model: PhotoModel) {
        if let url = URL(string: model.src.medium) {
            let session = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data else { return }
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(data: data)
                }
            }
            session.resume()
        }
    }
}
