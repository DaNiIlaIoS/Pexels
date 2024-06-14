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
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
       let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        indicator.color = .darkGray
        return indicator
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
        addSubview(activityIndicator)
        setupConstraints()
    }
    
    private func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.top.trailing.bottom.leading.equalToSuperview()
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    func loadImage(witch model: PhotoModel) {
        activityIndicator.startAnimating()
        
        if let url = URL(string: model.src.medium) {
            let session = URLSession.shared.dataTask(with: url) { data, response, error in
                if self.urlAreSame(currentPhotoURl: model.src.medium, response: response?.url?.absoluteString) {
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                    }
                }
                
                guard let data = data else { return }
                
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(data: data)
                }
            }
            session.resume()
        }
    }
    
    private func urlAreSame(currentPhotoURl: String?, response: String?) -> Bool {
        guard let currentPhotoUrl = currentPhotoURl, let response = response else {
            print("Current photo URL or response url are absent")
            return false
        }
        guard currentPhotoUrl == response else {
            print("currentPhotoUrl and response are different")
            return false
        }
        return true
    }
}
