//
//  OnboardingViewController.swift
//  Pexels
//
//  Created by Даниил Сивожелезов on 20.05.2024.
//

import UIKit
import SnapKit

class OnboardingViewController: UIViewController {
    
    // MARK: - GUI Variables
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = view.frame.size
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(OnboardingCollectionViewCell.self, forCellWithReuseIdentifier: OnboardingCollectionViewCell.identifier)
        collectionView.isPagingEnabled = true
        return collectionView
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("Next".localized, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(named: String.appOrange)
        button.addTarget(self, action: #selector(nextButtonAction), for: .touchUpInside)
        button.titleLabel?.font = .systemFont(ofSize: 21, weight: .bold)
        return button
    }()
    
    private lazy var skipButton: UIButton = {
        let button = UIButton()
        button.setTitle("Skip".localized, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.alpha = 0.8
        button.backgroundColor = UIColor(named: String.appOrange)
        button.addTarget(self, action: #selector(skipButtonAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = pages.count
        pageControl.addTarget(self, action: #selector(pageAction(sender: )), for: .valueChanged)
        pageControl.currentPageIndicatorTintColor = UIColor(named: String.appOrange)
        pageControl.pageIndicatorTintColor = UIColor(named: String.appOrange)?.withAlphaComponent(0.5)
        return pageControl
    }()
    
    @objc func pageAction(sender: UIPageControl) {
        collectionView.scrollToItem(at: IndexPath(item: pageControl.currentPage, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    // MARK: - Properties
    static let key = "UserDidSeeOnboarding"
    private var pages: [OnboardingModel] = OnboardingModel.generatePages()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        nextButton.layer.cornerRadius = nextButton.frame.height / 2
        skipButton.layer.cornerRadius = skipButton.frame.height / 2
    }
    
    // MARK: - IBActions
    @objc func skipButtonAction() {
        start()
    }
    
    @objc func nextButtonAction() {
        
        if pageControl.currentPage == pageControl.numberOfPages - 1 {
            start()
            
        } else {
            pageControl.currentPage += 1
            collectionView.scrollToItem(at: IndexPath(item: pageControl.currentPage, section: 0),
                                        at: .centeredHorizontally,
                                        animated: true)
            
            handlePagesChanges()
        }
    }
    
    // MARK: - Methods
    private func start() {
        UserDefaults.standard.set(true, forKey: OnboardingViewController.key)
        
        let mainVC = MainViewController()
        let navigationController = UINavigationController()
        navigationController.viewControllers = [mainVC]
        view.window?.rootViewController = navigationController
        view.window?.makeKeyAndVisible()
    }
    
    private func handlePagesChanges() {
        if pageControl.currentPage == pageControl.numberOfPages - 1 {
            nextButton.setTitle("Start".localized, for: .normal)
            skipButton.isHidden = true
        } else {
            nextButton.setTitle("Next".localized, for: .normal)
            skipButton.isHidden = false
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(collectionView)
        view.addSubview(nextButton)
        view.addSubview(skipButton)
        view.addSubview(pageControl)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        nextButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(100)
            make.trailing.equalToSuperview().inset(-20)
            make.width.equalToSuperview().multipliedBy(0.4)
            make.height.equalTo(54)
        }
        
        skipButton.snp.makeConstraints { make in
            make.centerY.equalTo(nextButton.snp.centerY)
            make.leading.equalToSuperview().inset(-20)
            make.width.equalTo(nextButton).multipliedBy(0.9)
            make.height.equalTo(44)
        }
        
        pageControl.snp.makeConstraints { make in
            make.bottom.equalTo(nextButton.snp.top).offset(-30)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }
}

// MARK: - UICollectionViewDataSource
extension OnboardingViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCollectionViewCell.identifier, for: indexPath) as? OnboardingCollectionViewCell else { return UICollectionViewCell() }
        
        let onboardingModel = pages[indexPath.item]
        cell.configure(item: onboardingModel)
        
        return cell
    }
}

extension OnboardingViewController: UICollectionViewDelegate {
    
}

// MARK: - UIScrollViewDelegate
extension OnboardingViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / scrollView.frame.width)
        pageControl.currentPage = Int(pageIndex)
        handlePagesChanges()
    }
}
