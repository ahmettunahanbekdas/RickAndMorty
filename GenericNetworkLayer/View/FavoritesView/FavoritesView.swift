//
//  FavoritesView.swift
//  GenericNetworkLayer
//
//  Created by Ahmet Tunahan Bekdaş on 24.05.2024.
//

import UIKit

protocol FavoritesViewDelegate: AnyObject {
    func configureVC()
    func configureCollectionView()
    func reloadCollectionViewOnMainThread()
}

class FavoritesView: UIViewController {

    private var viewModel: FavoritesViewModel!
    private var favoritesCollectionView: UICollectionView!
    private var selectedCharacter: CombinedCharacter?
    
    init(viewModel: FavoritesViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.view = self
        viewModel?.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
    }
}

extension FavoritesView: FavoritesViewDelegate {
    func reloadCollectionViewOnMainThread() {
        DispatchQueue.main.async {
            self.favoritesCollectionView.reloadData()
        }
    }
    
    func configureVC() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "Favorites"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func configureCollectionView() {
        favoritesCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: CollectionViewHelper.createFavoritesFlowLayout())
        favoritesCollectionView.backgroundColor = .clear
        favoritesCollectionView.showsVerticalScrollIndicator = false
        favoritesCollectionView.register(FavoritesCell.self, forCellWithReuseIdentifier: FavoritesCell.identifier)
        favoritesCollectionView.translatesAutoresizingMaskIntoConstraints = false

        favoritesCollectionView?.delegate = self
        favoritesCollectionView?.dataSource = self
        
        view.addSubview(favoritesCollectionView)
    }
    
}
extension FavoritesView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.favoriteCharacter.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoritesCell.identifier, for: indexPath) as! FavoritesCell
        cell.setCell(character: viewModel.favoriteCharacter[indexPath.item])
         return cell
    }
}





    

