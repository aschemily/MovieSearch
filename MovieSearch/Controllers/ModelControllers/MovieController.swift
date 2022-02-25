//
//  MovieController.swift
//  MovieSearch
//
//  Created by Emily Asch on 2/24/22.
//

import Foundation

class MovieController{
    //api key: d4d46debf9af5f839e76cd13507d47ed
    //search query: https://api.themoviedb.org/3/search/movie?api_key={api_key}&query=Jack+Reacher
    //images query: https://image.tmdb.org/t/p/w500/{kqjL17yufvn9OVLyXYpvtyrFfak.jpg}

    //MARK: Constraints for url
    static let baseURL = URL(string: "https://api.themoviedb.org/3/search/movie")
    static let imageBaseURL = URL(string:"https://image.tmdb.org/t/p/w500/")
    
    static let apiKeyKey = "key"
    static let apiKeyValue = "d4d46debf9af5f839e76cd13507d47ed"
    static let queryKey = "query"
    
    
    //fetch movies with completion handler
    static func fetchMovies(movieSearched: String, completion: @escaping(Result<[Movie], NetworkError>)->Void){
        guard let baseURL = baseURL else{
            return completion(.failure(.invalidURL))
        }
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        let apiQuery = URLQueryItem(name: apiKeyKey, value: apiKeyValue)
        let movieNameSearched = URLQueryItem(name: queryKey, value: movieSearched)
        
        components?.queryItems = [apiQuery, movieNameSearched]
        
        guard let finalURL = components?.url else {return completion(.failure(.invalidURL))}
        print("👀final url \(#function) \(finalURL)👀")
        
        //DATA Session
        
        URLSession.shared.dataTask(with: finalURL) { data, _, error in
            if let error = error{
                return completion(.failure(.thrownError(error)))
            }
            guard let data = data else {return completion(.failure(.noData))}
            
            do{
                let topLevelObject = try JSONDecoder().decode(Movies.self, from: data)
                let movieData = topLevelObject.movie
               // return completion(.success(movieData))
                var allMovies: [Movie] = []
                for movie in movieData{
                    allMovies.append(movie)
                }
                return completion(.success(allMovies))
            }catch{
                return completion(.failure(.unableToDecode))
            }
        }.resume()
    }
    
    
}//end of class
