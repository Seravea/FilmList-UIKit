//
//  TableViewController.swift
//  FilmListUIKit
//
//  Created by Romain Poyard on 02/08/2023.
//

import UIKit

class TableViewController: UITableViewController {

    var popularMovies: [Movie] = []
    var genres: [Genre] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Les films populaires"
        
       
        Task {
            await loadPopularMovies()
            await loadOfficialGenres()
            
        }
        
    }

    // MARK: - Table view data source

    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return popularMovies.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! TableViewCell
        
        let movie = popularMovies[indexPath.row]
        
        cell.configureCell(movie: movie)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "DetailsView") as? MovieDetailsViewController {
            
            let movie = popularMovies[indexPath.row]
             
            vc.selectedMovie = movie
            
            vc.genres = addingGenresToMovie(movie: movie)
            
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }

}



// load Movies functions
extension TableViewController {
    
    func loadPopularMovies() async {
        let headers = [
            "accept": "application/json",
            "Authorization": "Bearer eed456115041deb5c36ed519eafea41a"
        ]
        let apiKey = "eed456115041deb5c36ed519eafea41a"
        do {
            guard let url = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=\(apiKey)&language=fr-FR&page=1") else {
                print("Couldn't load URL")
                return
            }
            
            
            var URLRequest = URLRequest(url: url)
            URLRequest.httpMethod = "GET"
            URLRequest.allHTTPHeaderFields = headers
            
            
            let (data, networkResponse) = try await URLSession.shared.data(for: URLRequest)
            
            guard (networkResponse as? HTTPURLResponse)?.statusCode == 200 else {
                fatalError("Error when fetching data on the URLSession \(networkResponse)")
            }
            
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(PopularMoviesResponse.self, from: data)
                    
            self.popularMovies = decodedData.results.sorted(by: {$0.voteAverage > $1.voteAverage})
            self.tableView.reloadData()
           
        }catch {
           
            let ac = UIAlertController(title: "error", message: "\(error)", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            
            self.present(ac, animated: true)
            
            
        }
    }
    
    
    func loadOfficialGenres() async {
        let headers = [
            "accept": "application/json",
            "Authorization": "Bearer eed456115041deb5c36ed519eafea41a"
        ]
        let apiKey = "eed456115041deb5c36ed519eafea41a"
        do {
            guard let url = URL(string: "https://api.themoviedb.org/3/genre/movie/list?api_key=\(apiKey)&language=fr-FR&page=1") else {
                print("Couldn't load URL")
                return
            }
            
            
            var URLRequest = URLRequest(url: url)
            URLRequest.httpMethod = "GET"
            URLRequest.allHTTPHeaderFields = headers
            
            
            let (data, networkResponse) = try await URLSession.shared.data(for: URLRequest)
            
            guard (networkResponse as? HTTPURLResponse)?.statusCode == 200 else {
                fatalError("Error when fetching data on the URLSession \(networkResponse)")
            }
            
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(GenreResponseBody.self, from: data)
                    
            // test GET genres
            // print(decodedData.genres.count)
            self.genres = decodedData.genres
            
        }catch {
            fatalError("error when fetching data from TheMovieDatabase \(error)")
        }
    }
    
    func addingGenresToMovie(movie : Movie) -> [String] {
        
        var result: [String] = []
        for genreID in movie.genreIDS {
            for genre in self.genres {
                if genre.id == genreID {
                    result.append(genre.name)
                }
            }
        }
        
        return result
    }
    
    
}
