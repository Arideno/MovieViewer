//
//  FavoriteMoviesPresenter.swift
//  MovieViewer
//
//  Created by Andrii Moisol on 22.09.2020.
//

import Foundation
import UIKit
import CoreData

class FavoriteMoviesPresenter: MoviesPresenter {
    override var movies: [Movie] {
        return model.favoriteMovies
    }
    
    override func getMovies(page: Int, completion: @escaping () -> ()) {
        self.model.getFavoriteMovies {
            completion()
        }
    }
}

extension FavoriteMoviesPresenter: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! MovieCell
        cell.imageView.kf.indicatorType = .activity
        DispatchQueue.main.async {
            cell.imageView.kf.setImage(with: URL(string: IMAGES_URL + self.movies[indexPath.item].posterPath), options: [.transition(.fade(0.2))])
        }
        return cell
    }
}
