//
//  MovieViewController.swift
//  DecadeOfMovies
//
//  Created by Yousef Hamza on 7/18/20.
//  Copyright © 2020 yousefahmza. All rights reserved.
//

import UIKit

class MovieViewController: UIViewController {

    lazy var movieView = MovieView()
    let movie: MovieMO

    init(movie: MovieMO) {
        self.movie = movie
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = movieView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Details"

        movieView.delegate = self
        movieView.show(movie: movie)
    }
}

extension MovieViewController: MovieViewDelegate {
    func movieViewDidSelectGenres(_ moviesView: MovieView) {
        navigationController?.pushViewController(TextsTableViewController(title: "Genres",
                                                                          texts: movie.genres as [String]? ?? []), animated: true)
    }

    func movieViewDidSelectCast(_ moviesView: MovieView) {
        navigationController?.pushViewController(TextsTableViewController(title: "Cast",
                                                                          texts: movie.cast as [String]? ?? []), animated: true)
    }

    func moviesViewDidSelectImages(_ moviesView: MovieView) {
        navigationController?.pushViewController(FlickerImagesCollectionViewController(movieTitle: movie.title ?? ""), animated: true)
    }
}
