//
//  ViewController.swift
//  MovieApp
//
//  Created by Ramya K on 25/10/24.
//

import UIKit


class MovieViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak private var tableView: UITableView!
    
    @IBOutlet weak private var searchBar: UISearchBar!
    
    private let viewModel = MovieViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.loadMovies()
        setUpSearchBar()
        setupTableView()
        configureBackButton()
    }
    
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MovieDetailsCell.loadNib(), forCellReuseIdentifier: Constants.MovieDetailsCell)
        tableView.register(MovieListCell.loadNib(), forCellReuseIdentifier: Constants.MovieListCell)
    }
    
    
    private func setUpSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = Constants.searchBarPlaceholder
    }
    
    
    private func configureBackButton() {
        let backButtonItem = UIBarButtonItem()
        backButtonItem.title = ""
        navigationItem.backBarButtonItem = backButtonItem
    }
}


extension MovieViewController {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.isSearching ? 1 : viewModel.sections.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if viewModel.isSearching {
            return viewModel.filteredMovies.count
        }
        
        let sectionData = viewModel.sections[section]
        
        guard sectionData.isOpened else {
            return 1
        }
        switch section {
        case 0:
            return viewModel.years.count + 1 // 1 extra for Title row
        case 1:
            return viewModel.genres.count + 1
        case 2:
            return viewModel.directors.count + 1
        case 3:
            return viewModel.actors.count + 1
        case 4:
            return viewModel.movies.count + 1
        default:
            return 1
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return viewModel.isSearching ? dequeueSearchingCell(for: indexPath) : dequeueRegularCell(for: indexPath)
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 && !viewModel.isSearching {
            toggleSectionOpening(at: indexPath.section)
        } else if indexPath.section == 4 || viewModel.isSearching {
            showMovieDetails(for: indexPath)
        } else {
            showMovieList(for: indexPath)
        }
        
        tableView.reloadSections([indexPath.section], with: .none)
    }
    
    
    private func dequeueSearchingCell(for indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.MovieDetailsCell, for: indexPath) as! MovieDetailsCell
        let movie = viewModel.filteredMovies[indexPath.row]
        cell.updateView(movie: movie)
        return cell
    }
    
    
    private func dequeueRegularCell(for indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            return dequeueSectionHeaderCell(for: indexPath)
        } else if indexPath.section < 4 {
            return dequeueItemCell(for: indexPath)
        } else {
            return dequeueAllMoviesCell(for: indexPath)
        }
    }
    
    
    private func dequeueSectionHeaderCell(for indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.MovieListCell, for: indexPath) as! MovieListCell
        cell.updateTitleLabel(with: viewModel.sections[indexPath.section].title)
        return cell
    }
    
    
    private func dequeueItemCell(for indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.MovieListCell, for: indexPath) as! MovieListCell
        let adjustedRow = indexPath.row - 1
        
        switch indexPath.section {
        case 0:
            cell.updateTitleLabel(with: viewModel.years[adjustedRow])
        case 1:
            cell.updateTitleLabel(with: viewModel.genres[adjustedRow])
        case 2:
            cell.updateTitleLabel(with: viewModel.directors[adjustedRow])
        case 3:
            cell.updateTitleLabel(with: viewModel.actors[adjustedRow])
        default:
            break
        }
        return cell
    }
    
    
    private func dequeueAllMoviesCell(for indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.MovieDetailsCell, for: indexPath) as! MovieDetailsCell
        let movie = viewModel.movies[indexPath.row - 1]
        cell.updateView(movie: movie)
        return cell
    }
    
    
    private func toggleSectionOpening(at section: Int) {
        viewModel.sections[section].isOpened.toggle()
    }
    
    
    private func showMovieDetails(for indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: Constants.MovieDetailsViewController, bundle: nil)
        guard let movieDetailsVC = storyboard.instantiateViewController(withIdentifier: Constants.MovieDetailsViewController) as? MovieDetailsViewController else { return }
        
        if viewModel.isSearching {
            movieDetailsVC.movie = viewModel.filteredMovies[indexPath.row]
        } else {
            movieDetailsVC.movie = viewModel.movies[indexPath.row - 1]
        }
        navigationController?.pushViewController(movieDetailsVC, animated: false)
    }
    
    
    private func showMovieList(for indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: Constants.MovieListViewController, bundle: nil)
        guard let movieListVC = storyboard.instantiateViewController(withIdentifier: Constants.MovieListViewController) as? MovieListViewController else { return }
        
        switch indexPath.section {
        case 0: movieListVC.movies = viewModel.moviesByYear(viewModel.years[indexPath.row - 1])
        case 1: movieListVC.movies = viewModel.moviesByGenre(viewModel.genres[indexPath.row - 1])
        case 2: movieListVC.movies = viewModel.moviesByDirector(viewModel.directors[indexPath.row - 1])
        case 3: movieListVC.movies = viewModel.moviesByActor(viewModel.actors[indexPath.row - 1])
        default:
            break
        }
        navigationController?.pushViewController(movieListVC, animated: false)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if viewModel.isSearching {
            return 180
        }
        return (indexPath.row == 0 || indexPath.section < 4) ? 50 : 180
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.isSearching = !searchText.isEmpty
        viewModel.filteredMovies = viewModel.isSearching ? viewModel.movies.filter { movie in
            guard let title = movie.Title, let genre = movie.Genre, let actors = movie.Actors, let director = movie.Director else { return false }
            let lowercasedSearchText = searchText.lowercased()
            return title.lowercased().contains(lowercasedSearchText) ||
            genre.lowercased().contains(lowercasedSearchText) ||
            actors.lowercased().contains(lowercasedSearchText) ||
            director.lowercased().contains(lowercasedSearchText)
        } : []
        
        tableView.reloadData()
    }
}



