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

	let reuseIdentifier = "movie cell"
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
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

