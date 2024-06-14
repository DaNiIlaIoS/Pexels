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
    init(apiManager: APIManager = APIManager.shared) {
        self.apiManager = apiManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Pexels"
        
        setupUI()
        
        historyCollectionView.register(HistoryCollectionViewCell.self, forCellWithReuseIdentifier: "HistoryCollectionViewCell")
        photosCollectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: "PhotoCollectionViewCell")
        
        searchBar.placeholder = "search image".localized
        searchBar.delegate = self
        
        searchTextArray = getSaveSearchText()
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
            make.leading.trailing.equalToSuperview().inset(8)
            make.height.equalTo(60)
        }
        
        photosCollectionView.snp.makeConstraints { make in
            make.top.equalTo(historyCollectionView.snp.bottom).offset(5)
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(5)
        }
    }
    
    @objc
    private func loadData() {
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
        searchTextArray = existingArray
    }
    
    private func getSaveSearchText() -> [String] {
        let array: [String] = UserDefaults.standard.stringArray(forKey: "userDefaults") ?? []
        return array
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
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = photos[indexPath.item]
        let url = photo.src.large2X
        
        let imageScrollViewController = ImageScrollViewController(imageURL: url)
        self.navigationController?.pushViewController(imageScrollViewController, animated: true)
    }
}

