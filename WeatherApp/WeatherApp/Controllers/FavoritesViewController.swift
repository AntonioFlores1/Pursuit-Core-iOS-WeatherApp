//
//  FavoritesViewController.swift
//  WeatherApp
//
//  Created by antonio  on 2/3/20.
//  Copyright © 2020 Pursuit. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {

    @IBOutlet weak var favoriteCollectionView: UICollectionView!
    
    
    var imagesArray = [Favorite]() {
        didSet{
            self.favoriteCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favoriteCollectionView.dataSource = self
        favoriteCollectionView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getImages()
    }
    func getImages(){
        imagesArray = FavoritesModel.getFavoritedImages()
    }
    
    

}
extension FavoritesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let collectionCell = favoriteCollectionView.dequeueReusableCell(withReuseIdentifier: "favorite", for: indexPath) as? FavoritesCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let cellInfo = imagesArray[indexPath.row]
        
        collectionCell.favoriteImage.image = UIImage(data: cellInfo.imageData)
        return collectionCell
    }
}

extension FavoritesViewController: UICollectionViewDelegate {
    
}
