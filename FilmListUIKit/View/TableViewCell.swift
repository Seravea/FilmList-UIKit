//
//  TableViewCell.swift
//  FilmListUIKit
//
//  Created by Romain Poyard on 02/08/2023.
//

import UIKit

class TableViewCell: UITableViewCell {
    @IBOutlet var posterImageView: UIImageView!
    
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var upcomingDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(movie: Movie) {
        
        layer.cornerRadius = 5
        posterImageView.load(url: movie.posterURL)
        posterImageView.layer.cornerRadius = 6
        titleLabel.text = movie.title
        
        
        upcomingDateLabel.text = movie.releaseDate
        
    }

}


extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}


extension AlignedAspectFitImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
