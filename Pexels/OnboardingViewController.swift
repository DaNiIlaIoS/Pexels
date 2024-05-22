//
//  OnboardingViewController.swift
//  Pexels
//
//  Created by Даниил Сивожелезов on 20.05.2024.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    var pages: [OnboardingModel] = [] {
        didSet {
//            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(UINib(nibName: OnboardingCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: OnboardingCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        generatePages()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        skipButton.layer.cornerRadius = skipButton.frame.height / 2
        nextButton.layer.cornerRadius = nextButton.frame.height / 2
    }

    @IBAction func skipButtonAction(_ sender: UIButton) {
        
    }
    @IBAction func nextButtonAction(_ sender: UIButton) {
        
    }
    
    func generatePages() {
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
        
        let onboardingModel = pages[indexPath.row]
        cell.setup(onboardingModel: onboardingModel)
        
        return cell
    }
}

extension OnboardingViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
}
