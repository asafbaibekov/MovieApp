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
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		self.movies = MovieCoreDataHandler.getMovies()
		self.movies!.sort(by: { $0.releaseYear < $1.releaseYear })
		self.tableView.reloadData()
	}

	func fetchFromApiAndSave() {
		let url = URL(string: "https://api.androidhive.info/json/movies.json")!
		let decoder = JSONDecoder()
		if let data: Data = try? Data(contentsOf: url), let movies = try? decoder.decode([MovieJSON].self, from: data) {
			if MovieCoreDataHandler.cleanDelete() {
				movies.forEach { MovieCoreDataHandler.saveObeject(movie: $0) }
			}
		}
	}

}

