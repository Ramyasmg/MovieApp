//
//  MovieCell.swift
//  MovieApp
//
//  Created by Ramya K on 25/10/24.
//

import UIKit

class MovieListCell: UITableViewCell {
    
    @IBOutlet weak private var titleLabel: UILabel!
    
    
    static func loadNib() -> UINib {
        return UINib(nibName: Constants.MovieListCell, bundle: .main)
    }
    
  
    func updateTitleLabel(with text: String) {
        titleLabel.text = text
    }
    
}
