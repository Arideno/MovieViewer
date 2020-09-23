//
//  DetailPresenter.swift
//  MovieViewer
//
//  Created by Andrii Moisol on 22.09.2020.
//

import UIKit
import CoreData

class DetailPresenter: NSObject {
    var movie: Movie!
    
    var title: String {
        return movie.title
    }
    
    var backdrop: String {
        return movie.backdropPath
    }
    
    var releaseDate: String {
        return movie.releaseDate
    }
    
    var overview: String {
        return movie.overview
    }
    
    lazy var favorite: Bool = {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request: NSFetchRequest = FavoriteMovie.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", movie.id)
        do {
            let movies = try context.fetch(request)
            if let movie = movies.first {
                return true
            } else {
                return false
            }
        } catch {
            print(error)
        }
        
        return false
    }()
    
    func toggleFavorite(completion: @escaping (Bool) -> ()) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request: NSFetchRequest = FavoriteMovie.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", movie.id)
        do {
            let movies = try context.fetch(request)
            if movies.count > 0 {
                for movie in movies {
                    context.delete(movie)
                }
                completion(false)
            } else {
                let mov = FavoriteMovie(context: context)
                mov.id = Int32(movie.id)
                mov.backdrop = movie.backdropPath
                mov.poster = movie.posterPath
                mov.releaseDate = movie.releaseDate
                mov.title = movie.title
                mov.overview = movie.overview
                completion(true)
            }
        } catch {
            print(error)
        }
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    func setMovie(movie: Movie) {
        self.movie = movie
    }
}
