//
//  MovieViewModel.swift
//  MovieApp
//
//  Created by Ramya K on 25/10/24.
//


import Foundation

class MovieViewModel {
    
    var movies: [Movie] = []
    
    var years: [String] {
        Array(Set(movies.compactMap { $0.Year })).sorted()
    }
    
    var genres: [String] {
        uniqueSortedGenres()
    }
    
    var directors: [String] {
        uniqueSortedDirectors()
    }
    
    var actors: [String] {
        uniqueSortedActors()
    }
    
    var sections: [Section] = [
        Section(title: "Year", isOpened: false),
        Section(title: "Genre", isOpened: false),
        Section(title: "Directors", isOpened: false),
        Section(title: "Actors", isOpened: false),
        Section(title: "All Movies", isOpened: false)
    ]
    
    var filteredMovies: [Movie] = []
    
    var isSearching = false
    
    
    private func uniqueSortedGenres() -> [String] {
        return uniqueSortedAttributes(from: movies.compactMap { $0.Genre })
    }
    
    
    private func uniqueSortedDirectors() -> [String] {
        return uniqueSortedAttributes(from: movies.compactMap { $0.Director })
    }
    
    
    private func uniqueSortedActors() -> [String] {
        return uniqueSortedAttributes(from: movies.compactMap { $0.Actors })
    }
    
    
    private func uniqueSortedAttributes(from attributeStrings: [String?]) -> [String] {
        var uniqueSet = Set<String>()
        for attributeString in attributeStrings {
            guard let attributeString = attributeString else { continue }
            let attributeArray = attributeString.split(separator: ",")
            for attribute in attributeArray {
                uniqueSet.insert(attribute.trimmingCharacters(in: .whitespaces))
            }
        }
        return Array(uniqueSet).sorted()
    }
    
    
    func loadMovies() {
        // Load movies from JSON
        if let url = Bundle.main.url(forResource: "MovieJson", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                self.movies = try decoder.decode([Movie].self, from: data)
                print(movies.count)
            } catch {
                print("Error loading movies: \(error)")
            }
        }
    }
    
    
    func moviesByYear(_ year: String) -> [Movie] {
        movies.filter { $0.Year?.contains(year) == true }
    }
    
    
    func moviesByGenre(_ genre: String) -> [Movie] {
        movies.filter { $0.Genre?.contains(genre) == true }
    }
    
    
    func moviesByDirector(_ director: String) -> [Movie] {
        movies.filter { $0.Director?.contains(director) == true }
    }
    
    
    func moviesByActor(_ actor: String) -> [Movie] {
        movies.filter { $0.Actors?.contains(actor) == true }
    }
    
}

