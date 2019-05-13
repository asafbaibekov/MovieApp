//
//  Movie.swift
//  MovieApp
//
//  Created by Asaf Baibekov on 13/05/2019.
//  Copyright © 2019 Asaf Baibekov. All rights reserved.
//

import UIKit

struct MovieJSON: Decodable {
	let title: String
	let image: URL
	let genre: [String]
	let rating: Double
	let releaseYear: Int16
	private enum CodingKeys: String, CodingKey {
		case title, image, rating, releaseYear, genre
	}
}
