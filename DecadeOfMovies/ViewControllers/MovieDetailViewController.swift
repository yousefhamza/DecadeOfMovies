//
//  MovieDetailViewController.swift
//  DecadeOfMovies
//
//  Created by Yousef Hamza on 7/18/20.
//  Copyright © 2020 yousefahmza. All rights reserved.
//

import UIKit

private let castTableViewReuseIdentifier = "cell"
private let genresCollectionViewreuseIdentifier = "cell"

class MovieDetailViewController: UIViewController {

    lazy var movieDetailView = MovieDetailView()
    let genresCollectionViewDataSource: GenresCollectionViewDataSource
    let castTableViewDataSource: CastTableViewDataSource
    let movie: MovieMO

    init(movie: MovieMO) {
        self.movie = movie
        self.genresCollectionViewDataSource = GenresCollectionViewDataSource(genres: movie.genres as [String]? ?? [],
                                                                             reuseIdentifier: genresCollectionViewreuseIdentifier)
        self.castTableViewDataSource = CastTableViewDataSource(cast: movie.cast as [String]? ?? [],
                                                               reuseIdentifier: castTableViewReuseIdentifier)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = movieDetailView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Details"

        movieDetailView.genresCollectionView.dataSource = genresCollectionViewDataSource
        movieDetailView.castTableView.dataSource = castTableViewDataSource

        movieDetailView.castTableView.register(UITableViewCell.classForCoder(),
                                         forCellReuseIdentifier: castTableViewReuseIdentifier)
        movieDetailView.genresCollectionView.register(GenresCollectionViewCell.self,
                                                 forCellWithReuseIdentifier: genresCollectionViewreuseIdentifier)

        movieDetailView.delegate = self
        movieDetailView.show(movie: movie)
    }
}

extension MovieDetailViewController: MovieViewDelegate {
    func moviesViewDidSelectImages(_ moviesView: MovieDetailView) {
        navigationController?.pushViewController(FlickerImagesCollectionViewController(movieTitle: movie.title ?? ""), animated: true)
    }
}
