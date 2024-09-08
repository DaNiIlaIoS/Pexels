//
//  MainViewController.swift
//  Pexels
//
//  Created by Даниил Сивожелезов on 29.05.2024.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {
    // MARK: - GUI Variables
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "search image".localized
        return searchBar
    }()
    
    private lazy var historyCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        
        return collectionView
    }()
    
    private lazy var photosCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let width = (view.frame.width - 15) / 2
        layout.itemSize = CGSize(width: width, height: width)
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(loadData), for: .valueChanged)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        return collectionView
    }()
    
    // MARK: - Properties
    private var apiManager = APIManager.shared
    
    var photos: [PhotoModel] = []
    var searchTextArray: [String] = [] {
        didSet {
            self.historyCollectionView.reloadData()
        }
    }
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Pexels"
        
        setupUI()
        
        historyCollectionView.register(HistoryCollectionViewCell.self, forCellWithReuseIdentifier: "HistoryCollectionViewCell")
        photosCollectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: "PhotoCollectionViewCell")
        
        searchBar.placeholder = "search image".localized
        searchBar.delegate = self
        
        resetSearchTextArray()
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
            make.height.equalTo(60)
            make.top.equalTo(searchBar.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(8)
        }
        
        photosCollectionView.snp.makeConstraints { make in
            make.top.equalTo(historyCollectionView.snp.bottom).offset(5)
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(5)
        }
    }
    
    private func updateHistoryHeight() {
        historyCollectionView.snp.updateConstraints { make in
            make.height.equalTo(searchTextArray.isEmpty ? 0 : 60)
        }
    }
    
    @objc private func loadData() {
        apiManager.search(searchBar) { [weak self] result in
            DispatchQueue.main.async {
                if self?.photosCollectionView.refreshControl?.isRefreshing == false {
                    self?.photosCollectionView.refreshControl?.beginRefreshing()
                }
                
                switch result {
                    
                case .success(let data):
                    if self?.photosCollectionView.refreshControl?.isRefreshing == true {
                        self?.photosCollectionView.refreshControl?.endRefreshing()
                    }
                    self?.photos = data
                    self?.photosCollectionView.reloadData()
                    self?.saveText(searchText: self?.searchBar.text ?? "")
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func saveText(searchText: String) {
        var existingArray = getSaveSearchText()
        existingArray.append(searchText)
        
        UserDefaults.standard.set(existingArray, forKey: "userDefaults")
        resetSearchTextArray()
        updateHistoryHeight()
    }
    
    private func getSaveSearchText() -> [String] {
        let array: [String] = UserDefaults.standard.stringArray(forKey: "userDefaults") ?? []
        return array
    }
    
    private func getReversedSearchArray() -> [String] {
        let reversedArray: [String] = getSaveSearchText().reversed()
        return reversedArray
    }
    
    private func getUniqueSearchArray() -> [String] {
        var uniqueArray: [String] = []
        getReversedSearchArray().forEach { value in
            if !uniqueArray.contains(value) {
                uniqueArray.append(value)
            }
        }
        return uniqueArray
    }
    
    private func resetSearchTextArray() {
        self.searchTextArray = getUniqueSearchArray()
    }
    
    private func deleteSearchText(at index: Int) {
        searchTextArray.remove(at: index)
        UserDefaults.standard.set(searchTextArray, forKey: "userDefaults")
        updateHistoryHeight()
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
        loadData()
    }
}

// MARK: - UICollectionViewDataSource
extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case photosCollectionView:
            return photos.count
        case historyCollectionView:
            return searchTextArray.count
        default:
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        switch collectionView {
        case photosCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as? PhotoCollectionViewCell else { return UICollectionViewCell() }
            
            let photo = photos[indexPath.row]
            cell.loadImage(witch: photo)
            
            return cell
            
        case historyCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HistoryCollectionViewCell", for: indexPath) as? HistoryCollectionViewCell else { return UICollectionViewCell() }
            
            cell.set(title: searchTextArray[indexPath.item])
            cell.deleteButtonWasTapped = {
                self.deleteSearchText(at: indexPath.item)
            }
            
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch collectionView {
        case photosCollectionView:
            let photo = photos[indexPath.item]
            let url = photo.src.large2X
            
            let imageScrollViewController = ImageScrollViewController(imageURL: url)
            self.navigationController?.pushViewController(imageScrollViewController, animated: true)
        case historyCollectionView:
            let searchText = searchTextArray[indexPath.item]
            searchBar.text = searchText
            loadData()
        default:
            print("Unknown collection view")
        }
    }
}
