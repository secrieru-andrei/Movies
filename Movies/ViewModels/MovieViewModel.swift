//
//  MovieViewModel.swift
//  Movies
//
//  Created by Secrieru Andrei on 10.11.2022.
//

import Foundation
import Combine

class MovieViewModel: ObservableObject {
    
    @Published var itemIndex: Int = 0
    @Published var itemId: Int = 0
    @Published var moviesCount = 0
    @Published var favoritesCount = 0
    private var apiService = ApiService()
    @Published var movies: [Movie] = []
    @Published var favorites: [Movie] = []
    
    init(){
        fetchData()
    }
}

//MARK: - Fetch Data

typealias MovieViewModelFetchData = MovieViewModel
extension MovieViewModelFetchData {
    func fetchData() {
        apiService.getMovies { [weak self] (result) in
            switch result {
            case .failure(let error):
                print("Error: \(error)")
            case.success(let result):
                self?.movies = result.movies
                self?.moviesCount = result.movies.count
            }
        }
    }
}

//MARK: - TableView Data

typealias ViewModelTableViewData = MovieViewModel
extension ViewModelTableViewData {
    func getNumberOfRows(section: Int) -> Int{
        return moviesCount
    }
    
    func getNumberOfFavorites(section: Int) -> Int {
        return favoritesCount
    }
    
    func cellForRowAt(indexPath: IndexPath) -> Movie {
        return movies[indexPath.row]
    }
    
    func favoritesCellForRowAt(indexPath: IndexPath) -> Movie {
        return favorites[indexPath.row]
    }
}

//MARK: - Favorites Control

typealias ViewModelFavoritesControl = MovieViewModel
extension ViewModelFavoritesControl {
    func saveToFavorites(movie: Movie){
        favorites.append(movie)
    }
    
    func removeFromFavorites(movie: Movie){
        favorites.removeAll(where: {$0.id == movie.id})
    }
    
    func checkMovieIsInFavorite(movie: Movie) -> Bool {
        if favorites.contains(where: {$0.id == movie.id}) {
          return true
        } else {
            return false
        }
    }
}
