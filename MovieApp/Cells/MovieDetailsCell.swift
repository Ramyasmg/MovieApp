//
//  TableViewCell.swift
//  MovieApp
//
//  Created by Ramya K on 25/10/24.
//

import UIKit

class MovieDetailsCell: UITableViewCell {
    
    @IBOutlet weak private var posterImageView: UIImageView!
    
    @IBOutlet weak private var title: UILabel!
    
    @IBOutlet weak private var language: UILabel!
    
    @IBOutlet weak private var yearLabel: UILabel!
    
    
    static func loadNib() -> UINib {
        return UINib(nibName: Constants.MovieDetailsCell, bundle: .main)
    }
    

    func updateView(movie: Movie) {
        title.text = movie.Title
        language.text = movie.Language
        if let year = movie.Year {
            yearLabel.text = "Year: \(year)"
        }
        ImageDownloader.shared.downloadImage(from: movie.Poster) { [weak self] image in
            DispatchQueue.main.async {
                self?.posterImageView.image = image
            }
        }
    }
    
}
