//
//  MovieTableViewController.swift
//  MovieSearch
//
//  Created by Emily Asch on 2/24/22.
//

import UIKit

class MovieTableViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    var movies: [String] = []
   
   
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }
    

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return movies.count
    }

 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       guard let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as? MovieTableViewCell else {return UITableViewCell()}
        
        let movie = movies[indexPath.row]
        
        cell.movie = movie
        return cell
    }

}//end of tableview controller

extension MovieTableViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchMovie = searchBar.text, !searchMovie.isEmpty else {return}
        
        MovieController.fetchMovies(movieSearched: searchMovie) { result in
            DispatchQueue.main.async {
                switch result{
                    //confused?
                case .success(let movies):
                    self.movies = movies
                    self.tableView.reloadData()
                case .failure(let error):
                    print("🔴error in \(#function), \(error.localizedDescription)🔴")
                }
            }
        }
    }
}
