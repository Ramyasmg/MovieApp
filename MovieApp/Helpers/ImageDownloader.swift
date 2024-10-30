//
//  ImageDownloader.swift
//  MovieApp
//
//  Created by Ramya K on 30/10/24.
//


import UIKit

class ImageDownloader {
    
    static let shared = ImageDownloader()
    
    
    private init() {}
    
    
    func downloadImage(from urlString: String?, completion: @escaping (UIImage?) -> Void) {
        guard let urlString = urlString,
              let url = URL(string: urlString)
        else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching image: \(error)")
                completion(nil)
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                print("Error converting data to image")
                completion(nil)
                return
            }
            completion(image)
        }.resume()
    }
}
