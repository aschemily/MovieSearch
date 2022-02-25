//
//  MovieTableViewCell.swift
//  MovieSearch
//
//  Created by Emily Asch on 2/24/22.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    
    @IBOutlet weak var movieRating: UILabel!
    @IBOutlet weak var movieDescription: UILabel!
    
    
    var movie: Movie?{
        didSet{
            updateViews()
        }
    }
    
    func updateViews(){
        guard let movie = movie
        else {return}
        
        movieTitle.text = movie.title
        movieRating.text = String(movie.rating)
        movieDescription.text = movie.description
        
        MovieController.fetchImageURL(movie: movie) { result in
            DispatchQueue.main.async {
                switch result{
                case .success(let image):
                    self.movieImage.image = image
                case .failure(let error):
                    self.movieImage.image = UIImage(systemName: "photo.on.rectangle")
                    print("🔴error in \(#function), \(error.localizedDescription)🔴")
                }
            }
        }
    }

}
