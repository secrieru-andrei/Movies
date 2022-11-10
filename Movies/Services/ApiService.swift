import Foundation

class ApiService {
    
    private var dataTask: URLSessionDataTask?
    
    typealias CompletionHandler = (Result<MoviesData, Error>)  -> Void
    
    func getMovies(completion: @escaping CompletionHandler) {
        let urlString = "https://api.themoviedb.org/3/movie/popular?api_key=4e0be2c22f7268edffde97481d49064a&language=en-US&page=1"
        
        guard let url = URL(string: urlString) else {return}
        
        dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                print("Error : \(error.localizedDescription)")
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                print("No Response")
                return
            }
            
            if response.statusCode == 200 {
                guard let data = data else {return}
                guard let result = self.parse(data: data) else {return}
                DispatchQueue.main.async {
                    completion(.success(result))
                }
            }
        }
        dataTask?.resume()
    }
    
    func parse(data: Data) ->MoviesData? {
        let decoder = JSONDecoder()
        guard let result = try? decoder.decode(MoviesData.self, from: data) else {return nil}
        return result
    }
}
