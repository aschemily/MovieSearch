//
//  MovieController.swift
//  MovieSearch
//
//  Created by Emily Asch on 2/24/22.
//

import Foundation
import UIKit

class MovieController{
    //api key: d4d46debf9af5f839e76cd13507d47ed
    //search query: https://api.themoviedb.org/3/search/movie?api_key={api_key}&query=Jack+Reacher
    //images query: https://image.tmdb.org/t/p/w500/{kqjL17yufvn9OVLyXYpvtyrFfak.jpg}
    
    //MARK: Constraints for url
    static let baseURL = URL(string: "https://api.themoviedb.org/3/search/movie")
    static let imageBaseURL = URL(string:"https://image.tmdb.org/t/p/w500")
    
    static let apiKeyKey = "api_key"
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
                //MARK: Come back
                let topLevelObject = try JSONDecoder().decode(Movies.self, from: data)
                let movieData = topLevelObject.results
                
                 return completion(.success(movieData))
               // var allMovies: [Movie] = []
//
//                for movie in movieData{
//                    allMovies.append(movie)
//                }
               // return completion(.success(allMovies))
            }catch{
                return completion(.failure(.unableToDecode))
            }
        }.resume()
    }
    
    //images query: https://image.tmdb.org/t/p/w500/{kqjL17yufvn9OVLyXYpvtyrFfak.jpg}
    static func fetchImageURL(movie: Movie, completion: @escaping(Result<UIImage, NetworkError>)->Void){
       guard let imageBaseURL = imageBaseURL,
             let movieImage = movie.image else {
                 return completion(.failure(.invalidURL))
             }
       let finalImageURL = imageBaseURL.appendingPathComponent(movieImage)
        //print("final image url: 🤞\(finalImageURL)🤞")
        
        URLSession.shared.dataTask(with: finalImageURL) { data, _, error in
            if let error = error{
                return completion(.failure(.thrownError(error)))
            }
            
            guard let data = data else {return completion(.failure(.noData))}
            
            guard let finalMovieImage = UIImage(data: data) else {return completion(.failure(.unableToDecode))}
          //  print("what is final image movie? 🛎\(finalMovieImage)🛎")
            return completion(.success(finalMovieImage))
        }.resume()
        
    }
    
    
}//end of class
