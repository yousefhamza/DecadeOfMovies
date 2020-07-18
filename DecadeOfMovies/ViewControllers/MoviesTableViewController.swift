//
//  MoviesTableViewController.swift
//  DecadeOfMovies
//
//  Created by Yousef Hamza on 7/18/20.
//  Copyright © 2020 yousefahmza. All rights reserved.
//

import UIKit
import CoreData

fileprivate let kMoviesTableViewCellIdentifier = "cell"
class MoviesTableViewController: UITableViewController {

    var fetchResultsController: NSFetchedResultsController<MovieMO> = MoviesStore.shared.fetchResultsController
    let searchController = UISearchController(searchResultsController: nil)
    var isSearching: Bool {
      return searchController.isActive && !(searchController.searchBar.text?.isEmpty ?? true)
    }

    init() {
        super.init(style: .grouped)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Movies"
         self.clearsSelectionOnViewWillAppear = false
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: kMoviesTableViewCellIdentifier)

        searchController.searchBar.placeholder = "Search Candies"
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            tableView.tableHeaderView = searchController.searchBar
        }
        definesPresentationContext = true

        importMovies()
    }

    fileprivate func fetchMovies() {
        do {
            try self.fetchResultsController.performFetch()
            self.tableView.reloadData()
        } catch {
            self.showLoadingFailureAlert()
        }
    }

    fileprivate func importMovies() {
        if MoviesStore.shared.hasImportedData  {
            fetchMovies()
        } else {
            MoviesStore.shared.importIfNeeded { (error) in
                guard error == nil || error == MoviesStoreError.alreadyImported else {
                    self.showImportFailureAlert()
                    return
                }
                self.fetchMovies()
            }
        }
    }

    fileprivate func showImportFailureAlert() {
        showFailureAlert(message: "Couldn't perform import", action: importMovies)
    }

    fileprivate func showLoadingFailureAlert() {
        showFailureAlert(message: "Couldn't fetch data", action: fetchMovies)
    }

    func showFailureAlert(message: String, action: @escaping ()->Void) {
        let alertController = UIAlertController(title: "Error",
                                                message: "Couldn't perform import",
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Retry", style: .default, handler: {  [weak self] (_) in
            self?.importMovies()
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        present(alertController, animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchResultsController.sections?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rowsCount = fetchResultsController.sections?[section].numberOfObjects ?? 0
        return isSearching ? min(rowsCount, 5) : rowsCount
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kMoviesTableViewCellIdentifier, for: indexPath)
        let movie = fetchResultsController.object(at: indexPath)
        cell.textLabel?.text = movie.title
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return fetchResultsController.sections?[section].name
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = fetchResultsController.object(at: indexPath)
        let movieViewController = MovieViewController(movie: movie)
        splitViewController?.showDetailViewController(UINavigationController(rootViewController: movieViewController),
                                                      sender: nil)
    }
}

extension MoviesTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text, text.isEmpty == false {
            fetchResultsController.fetchRequest.sortDescriptors = MovieMO.searchSortDescriptor
            fetchResultsController.fetchRequest.predicate = NSPredicate(format: "title CONTAINS[c] '\(text)'")
        } else {
            fetchResultsController.fetchRequest.sortDescriptors = MovieMO.normalSortDescriptor
            fetchResultsController.fetchRequest.predicate = nil
        }
        fetchMovies()
    }
}
