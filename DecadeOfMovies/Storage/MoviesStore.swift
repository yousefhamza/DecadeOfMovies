//
//  MoviesStore.swift
//  DecadeOfMovies
//
//  Created by Yousef Hamza on 7/18/20.
//  Copyright © 2020 yousefahmza. All rights reserved.
//

import Foundation
import CoreData

fileprivate let kMovieStoreHasFetchedKey = "kMovieStoreHasFetchedKey"

class MoviesStore {
    static private(set) var shared = MoviesStore()

    lazy var persistentContainer: NSPersistentContainer = {
        guard let momURL = Bundle(for: MoviesStore.self).url(forResource: "DecadeOfMovies",
                                                             withExtension: "momd"),
              let mom = NSManagedObjectModel(contentsOf: momURL) else {
                fatalError("Cannot find Managed object model")
        }
        let container = NSPersistentContainer(name: "DecadeOfMovies",
                                              managedObjectModel: mom)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    var hasImported = UserDefaults.standard.bool(forKey: kMovieStoreHasFetchedKey) {
        didSet {
            UserDefaults.standard.set(hasImported, forKey: kMovieStoreHasFetchedKey)
        }
    }

    var fetchResultsController: NSFetchedResultsController<MovieMO> {
        let fetchRequest = MovieMO.fetchRequest() as NSFetchRequest<MovieMO>
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "year", ascending: true),
            NSSortDescriptor(key: "title", ascending: true)
        ]
        let fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                managedObjectContext: persistentContainer.viewContext,
                                                                sectionNameKeyPath: "year",
                                                                cacheName: nil)
        return fetchResultsController
    }

    func importIfNeeded(completionHandler: ((MoviesStoreError?)->Void)?=nil) {
        guard hasImported == false else {
            completionHandler?(MoviesStoreError.alreadyImported)
            return
        }

        guard let moviesJSONURL = Bundle(for: MoviesStore.self).url(forResource: "movies", withExtension: "json") else {
            completionHandler?(MoviesStoreError.moviesJSONNotFound)
            return
        }

        let movies: [Movie]
        do {
            let data = try Data(contentsOf: moviesJSONURL)
            movies = try JSONDecoder().decode(MoviesJSON.self, from: data).movies
        } catch {
            completionHandler?(MoviesStoreError.importingDecodingError(error: error))
            return
        }
        persistentContainer.performBackgroundTask { [weak self] (context) in
            movies.forEach { (movie) in
                let movieMO = MovieMO(context: context)
                movieMO.title = movie.title
                movieMO.year = Int64(movie.year)
                movieMO.genres = movie.genres as [NSString]
                movieMO.cast = movie.cast as [NSString]
            }
            do {
                try context.save()
                self?.hasImported = true
                DispatchQueue.main.async {
                    completionHandler?(nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completionHandler?(MoviesStoreError.saveError(error: error))
                }
            }
        }
    }
}
