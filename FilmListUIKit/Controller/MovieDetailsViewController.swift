//
//  MovieDetailsViewController.swift
//  FilmListUIKit
//
//  Created by Romain Poyard on 02/08/2023.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    
    @IBOutlet var castingScrollView: UIScrollView!
    @IBOutlet var detailsScrollView: UIScrollView!
    @IBOutlet var genreCollectionView: UICollectionView!
    var selectedMovie: Movie?
    var genres: [String] = []
    
    var casting: MovieCasting?
    
    var arrayOfActorsView: [CastingView] = []
    

    @IBOutlet var moviePoster: UIImageView!
    @IBOutlet var movieResume: UILabel!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        
        
        genreCollectionView.isScrollEnabled = false
        if let movie = selectedMovie {
            
            
            
            
            title = movie.title
            moviePoster.load(url: movie.posterURL)
            movieResume.text = movie.overview
            
            genreCollectionView.dataSource = self
            genreCollectionView.delegate = self
            genreCollectionView.reloadData()
            
            
        }
        
        
       
    }
   
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
        
        if let movie = selectedMovie {
            Task {
                await loadMovieActors(id: movie.id)
                
                
                for index in 0...casting!.cast.count / 8 {
                    
                    let testCastingView = CastingView()
                    
                    testCastingView.configureActorCell(actorID: casting!.cast[index].id, actorName: casting!.cast[index].name)
                    
                    arrayOfActorsView.append(testCastingView)
                    
                }
                
                
                let scrollViewSize = arrayOfActorsView.count  > 4 ? CGFloat(arrayOfActorsView.count * 130) : view.frame.size.width
                
                let scrollViewUIViewContainer = UIView()
                scrollViewUIViewContainer.frame.size = CGSize(width: view.frame.size.width, height: 150)
                scrollViewUIViewContainer.contentMode = .bottom
                
                let hStackView = UIStackView(arrangedSubviews: arrayOfActorsView)
                
                hStackView.axis = .horizontal
                hStackView.frame.size = CGSize(width: scrollViewSize, height: 150)
                hStackView.alignment = .leading
                hStackView.distribution = .fillEqually
                hStackView.spacing = 5
                hStackView.contentMode = .bottom
                scrollViewUIViewContainer.addSubview(hStackView)
               
                
              
                castingScrollView.contentSize = CGSize(width: scrollViewSize, height: 140)
                castingScrollView.addSubview(scrollViewUIViewContainer)
                
                NSLayoutConstraint.activate([
                    hStackView.trailingAnchor.constraint(equalTo: scrollViewUIViewContainer.trailingAnchor),
                    hStackView.leadingAnchor.constraint(equalTo: scrollViewUIViewContainer.leadingAnchor),
                    hStackView.topAnchor.constraint(equalToSystemSpacingBelow: scrollViewUIViewContainer.topAnchor, multiplier: 1),
                    scrollViewUIViewContainer.topAnchor.constraint(equalToSystemSpacingBelow: castingScrollView.topAnchor, multiplier: 1),
                    scrollViewUIViewContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                    castingScrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                    castingScrollView.topAnchor.constraint(equalTo: movieResume.bottomAnchor),
                    castingScrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)

                ])
            }
        }
    }

}




extension MovieDetailsViewController {
    
    func loadMovieActors(id: Int) async {
        
       let headers =  [
            "accept": "application/json",
            "Authorization": "Bearer eed456115041deb5c36ed519eafea41a"
       ]
        let apiKey = "eed456115041deb5c36ed519eafea41a"
        do {
            guard let url = URL(string: "https://api.themoviedb.org/3/movie/\(id)/credits?api_key=\(apiKey)&language=fr-FR") else {
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
            let decodedData = try decoder.decode(MovieCasting.self, from: data)
                    
            self.casting = decodedData
            
        }catch {
            fatalError("error when fetching data from TheMovieDatabase \(error)")
        }
        
    }
    
}


extension MovieDetailsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        return genres.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GenreCell", for: indexPath) as! GenreCollectionViewCell
        
        let genre = genres[indexPath.row]
        
        cell.configureGenreCell(genre: genre)
     
        return cell
        
    }
    
    
    
    
    
    
}
