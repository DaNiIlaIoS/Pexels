//
//  MainViewController.swift
//  Pexels
//
//  Created by Даниил Сивожелезов on 29.05.2024.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {

//    @IBOutlet weak var searchBar: UISearchBar!
//    @IBOutlet weak var searchHistoryCollectionView: UICollectionView!
//    @IBOutlet weak var imagesCollectionView: UICollectionView!
    
    // MARK: - GUI Variables
    private lazy var searchBar: UISearchBar = {
       let searchBar = UISearchBar()
        searchBar.placeholder = "image search"
        return searchBar
    }()
    
    private lazy var historyCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 40), collectionViewLayout: layout)
        
        return collectionView
    }()
    
    private lazy var photosCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let width = (view.frame.width - 15) / 2
        layout.itemSize = CGSize(width: width, height: width)
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
//      layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: CGRect.init(x: 0, y: 0, width: view.frame.width, height: view.frame.height - (searchBar.frame.height + historyCollectionView.frame.height)), collectionViewLayout: layout)
        
        return collectionView
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Pexels"
        
        setupUI()
        
        historyCollectionView.register(HistoryCollectionViewCell.self, forCellWithReuseIdentifier: "HistoryCollectionViewCell")
        photosCollectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: "PhotoCollectionViewCell")
        
        searchBar.placeholder = "search image".localized
        searchBar.delegate = self
    }
    
    // MARK: - Methods
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(searchBar)
        view.addSubview(historyCollectionView)
        view.addSubview(photosCollectionView)
        
        setupConstraints()
    }
    private func setupConstraints() {
        searchBar.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        historyCollectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(5)
        }
        
        photosCollectionView.snp.makeConstraints { make in
            make.top.equalTo(historyCollectionView.snp.bottom)
            make.leading.bottom.trailing.equalToSuperview()
        }
    }
}

// MARK: - UISearchBarDelegate
extension MainViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        APIManager.search(searchBar)
    }
}



