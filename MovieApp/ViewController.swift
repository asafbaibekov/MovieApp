//
//  ViewController.swift
//  MovieApp
//
//  Created by Asaf Baibekov on 07/04/2019.
//  Copyright © 2019 Asaf Baibekov. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

	let imageCache = NSCache<NSString, UIImage>()

	var movies: [Movie]?

	@IBOutlet weak var tableView: UITableView!

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		
		fetchFromApiAndSave()
		self.movies = MovieCoreDataHandler.getMovies()
		self.movies!.sort { (first, second) -> Bool in
			return first.releaseYear < second.releaseYear
		}
	}

	func fetchFromApiAndSave() {
		let url = URL(string: "https://api.androidhive.info/json/movies.json")!
		if let data: Data = try? Data(contentsOf: url),
			let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: [.allowFragments]),
			let jsonArray = jsonResponse as? [[String: Any]] {
			if MovieCoreDataHandler.cleanDelete() {
				jsonArray.forEach { (item) in
					let title = item["title"] as! String
					let image = URL(string: item["image"] as! String)!
					let rating = item["rating"] as! Double
					let releaseYear = item["releaseYear"] as! Int16
					let genre = item["genre"] as! [String]
					MovieCoreDataHandler.saveObeject(title: title, image: image, rating: rating, releaseYear: releaseYear, genre: genre)
				}
			}
		}
	}

}

extension ViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.movies?.count ?? 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as? MovieTableViewCell {
			if let movies = movies {
				let movie = movies[indexPath.row]
				if let imageURL = movie.image {
					if let image = self.imageCache.object(forKey: imageURL.absoluteString as NSString) {
						cell.movieImageView.image = image
					} else {
						cell.movieImageView.image = nil
						DispatchQueue.global().async {
							if let data: Data = try? Data(contentsOf: imageURL),
								let image = UIImage(data: data) {
								self.imageCache.setObject(image, forKey: imageURL.absoluteString as NSString)
								DispatchQueue.main.async {
									cell.movieImageView.image = image
								}
							}
						}
					}
				}
				if let title = movie.title {
					cell.titleLabel.text = title
				}
				cell.releaseYearLabel.text = "\(movie.releaseYear)"
			}
			return cell
		}
		return UITableViewCell()
	}
}

extension ViewController: UITableViewDelegate {
	
}

