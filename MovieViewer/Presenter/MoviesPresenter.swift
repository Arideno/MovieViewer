//
//  MoviesPresenter.swift
//  MovieViewer
//
//  Created by Andrii Moisol on 22.09.2020.
//

import Foundation
import UIKit
import Kingfisher


class MoviesPresenter: NSObject {
    let model = MovieModel()
    var movies: [Movie] {
        return model.movies
    }
    let cellIdentifier = "Cell"
    
    func getMovies(page: Int, completion: @escaping () -> ()) {}
    
    func getMovieByIndex(_ index: Int) -> Movie {
        return movies[index]
    }
    
    func registerCells(for collectionView: UICollectionView) {
        collectionView.register(MovieCell.self, forCellWithReuseIdentifier: cellIdentifier)
    }
}
