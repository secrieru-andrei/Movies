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
    @Published var moviesCount = 0
    private var apiService = ApiService()
    @Published var movies: [Movie] = []
    
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
    
    func cellForRowAt(indexPath: IndexPath) -> Movie {
        return movies[indexPath.row]
    }
}
