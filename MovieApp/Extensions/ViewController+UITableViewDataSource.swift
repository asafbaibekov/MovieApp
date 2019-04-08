//
//  ViewController+UITableViewDataSource.swift
//  MovieApp
//
//  Created by Asaf Baibekov on 09/04/2019.
//  Copyright © 2019 Asaf Baibekov. All rights reserved.
//

import UIKit

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
