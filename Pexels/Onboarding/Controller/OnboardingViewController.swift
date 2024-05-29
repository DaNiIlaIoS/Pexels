//
//  OnboardingViewController.swift
//  Pexels
//
//  Created by Даниил Сивожелезов on 20.05.2024.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    
    // MARK: - Properties
    static let key = "UserDidSeeOnboarding"
    
    private var pages: [OnboardingModel] = [] {
        didSet {
            pageControl.numberOfPages = pages.count
            collectionView.reloadData()
        }
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(UINib(nibName: OnboardingCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: OnboardingCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        nextButton.setTitle("Next".localized, for: .normal)
        skipButton.setTitle("Skip".localized, for: .normal)
        
        generatePages()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        skipButton.layer.cornerRadius = skipButton.frame.height / 2
        nextButton.layer.cornerRadius = nextButton.frame.height / 2
    }
    
    // MARK: - IBActions
    @IBAction func skipButtonAction(_ sender: UIButton) {
        start()
    }
    
    @IBAction func nextButtonAction(_ sender: UIButton) {
        
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
    
    private func generatePages() {
        pages = [OnboardingModel(imageName: "onboarding1",
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

extension OnboardingViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCollectionViewCell.identifier, for: indexPath) as!
        OnboardingCollectionViewCell
        
        let onboardingModel = pages[indexPath.item]
        cell.setup(onboardingModel: onboardingModel)
        
        return cell
    }
}

extension OnboardingViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
}

extension OnboardingViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        print("scrollViewDidEndDecelerating \(scrollView.contentOffset.x)")
        
        pageControl.currentPage = Int(scrollView.contentOffset.x / scrollView.frame.width)
        
        handlePagesChanges()
    }
}
