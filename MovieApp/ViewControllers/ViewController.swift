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

	var movies: [Movie]?

	@IBOutlet weak var tableView: UITableView!

	let reuseIdentifier = "movie cell"
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		ApiHandler.shared.fetchMovies (complition: { (movies) in
			if MovieCoreDataHandler.cleanDelete() {
				movies.forEach { MovieCoreDataHandler.saveObeject(movie: $0) }
				self.refreshMovies()
			}
		})
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		refreshMovies()
	}

	func refreshMovies() {
		self.movies = MovieCoreDataHandler.getMovies()
		self.movies!.sort(by: { $0.releaseYear < $1.releaseYear })
		self.tableView.reloadData()
	}
}

extension ViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.movies?.count ?? 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let movies = movies else { return UITableViewCell() }
		var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
		if cell == nil {
			cell = UITableViewCell(style: .subtitle, reuseIdentifier: reuseIdentifier)
		}
		let movie = movies[indexPath.row]
		cell.textLabel?.text = movie.title
		cell.detailTextLabel?.text = "\(movie.releaseYear)"
		if let image = movie.imageData {
			cell.imageView?.image = UIImage(data: image)
		} else {
			cell.imageView?.image = nil
			ImageDownloader.addOperation(movie: movie, indexPath: indexPath) { [unowned self] indexPath in
				self.tableView.reloadRows(at: [indexPath], with: .fade)
			}
		}
		return cell
	}
}
