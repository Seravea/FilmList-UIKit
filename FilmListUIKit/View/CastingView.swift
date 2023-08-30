//
//  CastingView.swift
//  FilmListUIKit
//
//  Created by Romain Poyard on 04/08/2023.
//

import UIKit

class CastingView: UIView {
    var actorImage: AlignedAspectFitImageView!
    var actorNameLabel: UILabel!
    var actorURLsImage: [PersonImageURL] = []
   
    
    func configureActorCell(actorID: Int, actorName: String) {
        actorImage = AlignedAspectFitImageView()
        
        Task {
            await loadActorImages(actorID: actorID)
            
            if actorURLsImage.count > 0 {
                if let url = actorURLsImage[0].imageURL {
                    actorImage.load(url: url)
                    
                }
            }
        }
        
        
        self.frame.size.width = 110
        self.frame.size.height = 150
       
        
        
        
        
        actorImage.frame.size.height = 130
        actorImage.frame.size.width = 110
        
        
        
        //actorImage.contentMode =
        actorImage.aspectFill = true
        
        actorImage.verticalAlignment = .top
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 1
        //actorImage.bounds = self.frame.insetBy(dx: 10.0, dy: 10.0)
        self.addSubview(actorImage)
        
        actorNameLabel = UILabel()
        actorNameLabel.text = actorName
        
        
    }
    
    func loadActorImages(actorID: Int) async {
        let headers = [
          "accept": "application/json",
          "Authorization": "Bearer eed456115041deb5c36ed519eafea41a"
        ]
        
        let apiKey = "eed456115041deb5c36ed519eafea41a"
        do {
            guard let url = URL(string: "https://api.themoviedb.org/3/person/\(actorID)/images?api_key=\(apiKey)") else {
                print("Couldn't load URL")
                return
            }
            
            
            var URLRequest = URLRequest(url: url )
            URLRequest.httpMethod = "GET"
            URLRequest.allHTTPHeaderFields = headers
            
            
            
            let (data, networkResponse) = try await URLSession.shared.data(for: URLRequest)
            
            guard (networkResponse as? HTTPURLResponse)?.statusCode == 200 else {
                fatalError("Error when fetching data on the URLSession \(networkResponse)")
            }
            
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(ResponseImagesBody.self, from: data)
            self.actorURLsImage = decodedData.profiles
            
        }catch {
            fatalError("error when fetching data from TheMovieDatabase \(error)")
        }
        
        
    }

}


extension UIView {
    var ancestors: AnySequence<UIView> {
        return AnySequence<UIView>(
            sequence(first: self, next: { $0.superview }).dropFirst())
    }
}
