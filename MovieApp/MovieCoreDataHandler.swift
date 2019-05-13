//
//  CoreDataHandler.swift
//  MovieApp
//
//  Created by Asaf Baibekov on 07/04/2019.
//  Copyright © 2019 Asaf Baibekov. All rights reserved.
//

import UIKit
import CoreData

class MovieCoreDataHandler {
	private class func getContext() -> NSManagedObjectContext {
		let delegate = UIApplication.shared.delegate as! AppDelegate
		return delegate.persistentContainer.viewContext
	}

	class func saveObeject(movie: MovieJSON) {
		let context = getContext()
		let entity = NSEntityDescription.entity(forEntityName: "Movie", in: context)!

		let manageObject = NSManagedObject(entity: entity, insertInto: context)

		manageObject.setValue(movie.title, forKey: "title")
		manageObject.setValue(movie.image, forKey: "image")
		manageObject.setValue(movie.rating, forKey: "rating")
		manageObject.setValue(movie.releaseYear, forKey: "releaseYear")
		manageObject.setValue(movie.genre, forKey: "genre")

		do {
			try context.save()
		} catch {
			print("unable to save data")
		}
	}

	class func getMovies() -> [Movie]? {
		let contecxt = getContext()
		let fetchRequest: NSFetchRequest<Movie> = Movie.fetchRequest()
		if let movies = try? contecxt.fetch(fetchRequest) {
			return movies
		}
		return nil
	}
	
	class func getMovie(title: String) -> [Movie]? {
		let contecxt = getContext()
		let fetchRequest: NSFetchRequest<Movie> = Movie.fetchRequest()
		fetchRequest.predicate = NSPredicate(format: "title LIKE[cd] %@", title)
		if let movie = try? contecxt.fetch(fetchRequest) {
			return movie
		}
		return nil
	}

	class func deleteObject(movie: Movie) -> Bool {
		let context = getContext()
		context.delete(movie)
		do {
			try context.save()
			return true
		} catch {
			return false
		}
	}

	class func cleanDelete() -> Bool {
		let context = getContext()
		let delete = NSBatchDeleteRequest(fetchRequest: Movie.fetchRequest())
		do {
			try context.execute(delete)
			return true
		} catch {
			return false
		}
	}
}
