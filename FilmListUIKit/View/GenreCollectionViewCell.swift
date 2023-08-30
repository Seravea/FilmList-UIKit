//
//  GenreCollectionViewCell.swift
//  FilmListUIKit
//
//  Created by Romain Poyard on 02/08/2023.
//

import UIKit

class GenreCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var genreLabelView: UILabel!
    
    
    func configureGenreCell(genre: String) {
        genreLabelView.text = genre
        
    }
    
}
