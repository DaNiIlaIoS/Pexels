//
//  ImageScrollViewController.swift
//  Pexels
//
//  Created by Даниил Сивожелезов on 14.06.2024.
//

import UIKit
import SnapKit

final class ImageScrollViewController: UIViewController {
    // MARK: - GUI Variables
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.delegate = self
        return scrollView
    }()
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .large
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    // MARK: - Properties
    private var imageURL: String
    
    // MARK: - Life Cycle
    init(imageURL: String) {
        self.imageURL = imageURL
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadImage()
        setupZoom()
    }
    
    // MARK: - Properties
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        scrollView.addSubview(activityIndicator)
        scrollView.addSubview(imageView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
            make.width.height.equalToSuperview().multipliedBy(1)
        }
    }
    
    private func loadImage() {
        activityIndicator.startAnimating()
        
        guard let url = URL(string: imageURL) else { return }
        let session = URLSession.shared.dataTask(with: url) { data, _, error in
            
            if let error = error {
                print("Error: \(error.localizedDescription)")
                
            } else if let data = data {
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.imageView.image = UIImage(data: data)
                }
            }
        }
        session.resume()
    }
}

extension ImageScrollViewController: UIScrollViewDelegate {
    private func setupZoom() {
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 4
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
