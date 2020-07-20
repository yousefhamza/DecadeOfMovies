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
class MoviesTableViewController: UIViewController {
    let tableView = StatefulTableView(frame: .zero, style: .grouped)
    lazy var stateController = MoviesTableStateController()

    var fetchResultsController: NSFetchedResultsController<MovieMO> = MoviesStore.shared.fetchResultsController
    let searchController = UISearchController(searchResultsController: nil)
    var isSearching: Bool {
      return searchController.isActive && !(searchController.searchBar.text?.isEmpty ?? true)
    }

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Movies"
        view.addSubview(tableView)
        tableView.layoutFullyInSuperView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.stateDelegate = self
        tableView.stateDataSource = stateController
        tableView.contentInset = .zero
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

        if MoviesStore.shared.hasImportedData == false {
            stateController.didLoad(count: 0) // To show prompt for importing
            tableView.reloadData()
        } else {
            stateController.state = .normal
            fetchMovies()
        }
    }

    fileprivate func fetchMovies() {
        do {
            try fetchResultsController.performFetch()
            stateController.didLoad(count: fetchResultsController.fetchedObjects?.count ?? 0)
            tableView.reloadData()
        } catch {
            showLoadingFailureAlert()
        }
    }

    fileprivate func importMovies() {
        stateController.startLoading()
        tableView.reloadData()
        if MoviesStore.shared.hasImportedData  {
            fetchMovies()
        } else {
            MoviesStore.shared.importIfNeeded { (error) in
                guard error == nil || error == MoviesStoreError.alreadyImported else {
                    self.showImportFailureAlert()
                    return
                }
                self.stateController.state = .normal
                self.fetchMovies()
            }
        }
    }

    fileprivate func showImportFailureAlert() {
        stateController.didReceive(error: StateError(description: "Couldn't perform import."))
        tableView.reloadData()
    }

    fileprivate func showLoadingFailureAlert() {
        stateController.didReceive(error: StateError(description: "Couldn't fetch movies."))
        tableView.reloadData()
    }
}

extension MoviesTableViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchResultsController.sections?.count ?? 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rowsCount = fetchResultsController.sections?[section].numberOfObjects ?? 0
        return isSearching ? min(rowsCount, 5) : rowsCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kMoviesTableViewCellIdentifier, for: indexPath)
        let movie = fetchResultsController.object(at: indexPath)
        cell.textLabel?.text = movie.title
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}

extension MoviesTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return fetchResultsController.sections?[section].name
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = fetchResultsController.object(at: indexPath)
        let movieViewController = MovieViewController(movie: movie)
        splitViewController?.showDetailViewController(UINavigationController(rootViewController: movieViewController),
                                                      sender: nil)
    }
}

extension MoviesTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text, text.isEmpty == false {
            stateController.state = .search
            fetchResultsController.fetchRequest.sortDescriptors = MovieMO.searchSortDescriptor
            fetchResultsController.fetchRequest.predicate = NSPredicate(format: "title CONTAINS[c] '\(text)'")

        } else {
            stateController.state = MoviesStore.shared.hasImportedData ? .normal : .import
            fetchResultsController.fetchRequest.sortDescriptors = MovieMO.normalSortDescriptor
            fetchResultsController.fetchRequest.predicate = nil
        }
        fetchMovies()
    }
}

extension MoviesTableViewController: StateElementDelegate {
    func statefulElementDidTapReload() {
        importMovies()
    }
}
