//
//  ApiHandler.swift
//  MovieApp
//
//  Created by Asaf Baibekov on 23/05/2019.
//  Copyright © 2019 Asaf Baibekov. All rights reserved.
//

import UIKit

class ApiHandler {

	static let shared = ApiHandler()

	let url: URL

	private init() {
		url = URL(string: "https://api.androidhive.info/json/movies.json")!
	}

	func fetchMovies(complition: @escaping ([MovieJSON]) -> Void, failure: ((Error) -> Void)? = nil) {
		URLSession.shared.dataTask(with: url) { (data, response, error) in
			DispatchQueue.main.async {
				if let error = error, let failure = failure {
					failure(error)
				} else if let data = data {
					do {
						complition(try JSONDecoder().decode([MovieJSON].self, from: data))
					} catch {
						if let failure = failure {
							failure(error)
						}
					}
				}
			}
		}.resume()
	}
}
