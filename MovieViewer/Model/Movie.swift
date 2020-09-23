//
//  Movie.swift
//  MovieViewer
//
//  Created by Andrii Moisol on 22.09.2020.
//

import Foundation
import Alamofire
import CoreData

class MovieModel {
    typealias GetMoviesCompletion = () -> ()
    var movies: [Movie] = []
    var favoriteMovies: [Movie] = []
    var pages: Int = 0
    var currentPage: Int = 1
    
    func getMovies(page: Int, completion: @escaping GetMoviesCompletion) {
        self.currentPage = page
        let parameters = ["api_key": API_KEY, "page": String(page)]
        AF.request(POPULAR_URL, method: .get, parameters: parameters, encoder: URLEncodedFormParameterEncoder.default).response { response in
            switch response.result {
            case .success:
                if let jsonData = response.data {
                    do {
                        let movies = try JSONDecoder().decode(MovieListModel.self, from: jsonData)
                        self.movies = movies.results
                        self.pages = movies.pages
                        
                        completion()
                    } catch let error {
                        print(error.localizedDescription)
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func loadMovies(completion: @escaping GetMoviesCompletion) {
        currentPage += 1
        if currentPage < pages {
            let parameters = ["api_key": API_KEY, "page": String(currentPage)]
            AF.request(POPULAR_URL, method: .get, parameters: parameters, encoder: URLEncodedFormParameterEncoder.default).response { response in
                switch response.result {
                case .success:
                    if let jsonData = response.data {
                        do {
                            let movies = try JSONDecoder().decode(MovieListModel.self, from: jsonData)
                            self.movies += movies.results
                            
                            completion()
                        } catch let error {
                            print(error.localizedDescription)
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func getFavoriteMovies(completion: @escaping GetMoviesCompletion) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request: NSFetchRequest = FavoriteMovie.fetchRequest()
        do {
            let movies = try context.fetch(request)
            favoriteMovies = []
            for movie in movies {
                let m = Movie(id: Int(movie.id), poster: movie.poster!, backdrop: movie.backdrop!, title: movie.title!, releaseDate: movie.releaseDate!, overview: movie.overview!)
                favoriteMovies.append(m)
            }
            completion()
        } catch {
            print(error)
        }
    }
}

class Movie: Decodable {
    var id: Int
    var posterPath: String
    var backdropPath: String
    var title: String
    var releaseDate: String
    var overview: String
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case title = "title"
        case releaseDate = "release_date"
        case overview = "overview"
    }
    
    init(id: Int, poster: String, backdrop: String, title: String, releaseDate: String, overview: String) {
        self.id = id
        self.posterPath = poster
        self.backdropPath = backdrop
        self.title = title
        self.releaseDate = releaseDate
        self.overview = overview
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.id = (try? values.decode(Int.self, forKey: .id)) ?? -1
        self.posterPath = (try? values.decode(String.self, forKey: .posterPath)) ?? ""
        self.backdropPath = (try? values.decode(String.self, forKey: .backdropPath)) ?? ""
        self.title = (try? values.decode(String.self, forKey: .title)) ?? ""
        self.releaseDate = (try? values.decode(String.self, forKey: .releaseDate)) ?? ""
        self.overview = (try? values.decode(String.self, forKey: .overview)) ?? ""
    }
}

class MovieListModel: Decodable {
    var results: [Movie]
    var pages: Int
    
    private enum CodingKeys: String, CodingKey {
        case results = "results"
        case pages = "total_pages"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.results = (try? values.decode([Movie].self, forKey: .results)) ?? []
        self.pages = (try? values.decode(Int.self, forKey: .pages)) ?? 0
    }
}
