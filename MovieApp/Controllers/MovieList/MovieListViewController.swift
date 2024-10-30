//
//  MovieListViewController.swift
//  MovieApp
//
//  Created by Ramya K on 28/10/24.
//

import UIKit

class MovieListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    
    @IBOutlet weak private var tableView: UITableView!
    
    var movies: [Movie]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = Constants.navigationItemTitle
        configureTableView()
    }
    
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MovieDetailsCell.loadNib(), forCellReuseIdentifier: Constants.MovieDetailsCell)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.MovieDetailsCell, for: indexPath) as! MovieDetailsCell
        if let movie = movies?[indexPath.row] {
            cell.updateView(movie: movie)
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: Constants.MovieDetailsViewController, bundle: nil)
        if let movieDetailsVC = storyboard.instantiateViewController(withIdentifier: Constants.MovieDetailsViewController) as? MovieDetailsViewController {
            movieDetailsVC.movie = movies?[indexPath.row]
            navigationController?.pushViewController(movieDetailsVC, animated: false)
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
}
