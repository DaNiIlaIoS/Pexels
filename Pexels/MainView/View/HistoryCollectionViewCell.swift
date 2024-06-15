//
//  HistoryCollectionViewCell.swift
//  Pexels
//
//  Created by Даниил Сивожелезов on 11.06.2024.
//

import UIKit
import SnapKit

final class HistoryCollectionViewCell: UICollectionViewCell {
    
    // MARK: - GUI Variables
    private lazy var mainView: UIView = UIView()
    
    private lazy var cardView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.cornerRadius = 10
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var clockImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "clock")
        view.tintColor = .lightGray
        return view
    }()
    
    private lazy var historyLabel: UILabel = {
        let label = UILabel()
        label.text = "Nature"
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    lazy var deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .red
        button.addTarget(self, action: #selector(deleteButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Properties
    var deleteButtonWasTapped: (() -> ())?
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    private func setupUI() {
        addSubview(mainView)
        mainView.addSubview(cardView)
        cardView.addSubview(stackView)
        stackView.addArrangedSubview(clockImage)
        stackView.addArrangedSubview(historyLabel)
        stackView.addArrangedSubview(deleteButton)
        
        setupConstraints()
    }
    private func setupConstraints() {
        mainView.snp.makeConstraints { make in
            make.leading.top.trailing.bottom.equalToSuperview()
//            make.height.equalTo(60)
        }
        
        cardView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.leading.trailing.equalToSuperview().inset(8)
        }
        
        clockImage.snp.makeConstraints { make in
            make.width.height.equalTo(24)
        }
    }
    
    func set(title: String) {
        historyLabel.text = title
    }
    
    @objc func deleteButtonTapped(_ sender: UIButton) {
        bounce(button: sender) {
            self.deleteButtonWasTapped?()
        }
    }
    
    func bounce(button: UIButton, completion: @escaping (()->())) {
        UIView.animate(
            withDuration: 0.3,
            animations: {
                button.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            },
            completion: { _ in
                UIView.animate(withDuration: 0.3) {
                    button.transform = CGAffineTransform.identity
                } completion: { completed in
                    if completed {
                        completion()
                    }
                }
            }
        )
    }
}
