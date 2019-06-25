//
//  ImageDownloader.swift
//  MovieApp
//
//  Created by Asaf Baibekov on 25/06/2019.
//  Copyright © 2019 Asaf Baibekov. All rights reserved.
//

import UIKit

class ImageDownloader: Operation {
	
	static var downloadsInProgress: [IndexPath: Operation] = [:]
	static var downloadQueue: OperationQueue = {
		let queue = OperationQueue()
		queue.name = "Download queue"
		return queue
	}()
	
	let movie: Movie
	init(movie: Movie) {
		self.movie = movie
	}
	override func main() {
		guard !isCancelled else { return }
		guard let imageData = try? Data(contentsOf: movie.image!) else { return }
		guard !isCancelled else { return }
		if !imageData.isEmpty {
			movie.setValue(imageData, forKey: "imageData")
		}
	}
	
	class func addOperation(movie: Movie, indexPath: IndexPath, complition: ((IndexPath) -> Void)? = nil) {
		let operation = ImageDownloader(movie: movie)
		ImageDownloader.downloadsInProgress[indexPath] = operation
		operation.completionBlock = {
			guard !operation.isCancelled else { return }
			ImageDownloader.downloadsInProgress.removeValue(forKey: indexPath)
			DispatchQueue.main.async {
				complition?(indexPath)
			}
		}
		ImageDownloader.downloadQueue.addOperation(operation)
	}
}
