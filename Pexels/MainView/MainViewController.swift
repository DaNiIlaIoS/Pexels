//
//  MainViewController.swift
//  Pexels
//
//  Created by Даниил Сивожелезов on 29.05.2024.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchHistoryCollectionView: UICollectionView!
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Pexels"
        searchBar.placeholder = "search image".localized
    }
}
