//
//  MovieDetailsViewController.swift
//  MovieApp
//
//  Created by Ramya K on 28/10/24.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    
    @IBOutlet weak private var posterImageView: UIImageView!
    
    @IBOutlet weak private var titleLabel: UILabel!
    
    @IBOutlet weak private var moviePlotLabel: UILabel!
    
    @IBOutlet weak private var castLabel: UILabel!
    
    @IBOutlet weak private var releasedDateLabel: UILabel!
    
    @IBOutlet weak private var genreLabel: UILabel!
    
    @IBOutlet weak private var ratingView: UIView!
    
    @IBOutlet weak private var ratingValueLabel: UILabel!
    
    @IBOutlet weak private var ratingSourceLabel: UILabel!
    
    @IBOutlet weak private var ratingPickerView: UIPickerView!
    
    var movie: Movie?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
        configurePickerView()
        updateRating(with: movie?.Ratings?.first)
    }
    
    
    private func configurePickerView() {
        ratingPickerView.dataSource = self
        ratingPickerView.delegate = self
        ratingPickerView.isHidden = true
    }
    
    
    private func updateView() {
        guard let title = movie?.Title,
              let plot = movie?.Plot,
              let cast = movie?.Actors,
              let releasedDate = movie?.Released,
              let genre = movie?.Genre  else { return }
        titleLabel.text = title
        moviePlotLabel.text = plot
        castLabel.text = "Cast: \(cast)"
        releasedDateLabel.text = "Released Date: \(releasedDate)"
        genreLabel.text = "Genre: \(genre)"
        ImageDownloader.shared.downloadImage(from: movie?.Poster) { [weak self] image in
            DispatchQueue.main.async {
                self?.posterImageView.image = image
            }
        }
    }


    private func updateRating(with selectedRating: Rating?) {
        if let ratingSource = selectedRating?.Source,
           let ratingValue = selectedRating?.Value {
            ratingValueLabel.text = "Rating: \(ratingValue)"
            ratingSourceLabel.text = ratingSource
        }
    }
    
    
    @IBAction func dropDownButtonTapped(_ sender: Any) {
        ratingPickerView.isHidden = !ratingPickerView.isHidden
    }
    
}

extension MovieDetailsViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return movie?.Ratings?.count ?? 0
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return movie?.Ratings?[row].Source
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        updateRating(with:  movie?.Ratings?[row])
    }
    
}
