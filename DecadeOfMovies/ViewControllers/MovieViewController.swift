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

        movieView.show(movie: movie)
    }
}
