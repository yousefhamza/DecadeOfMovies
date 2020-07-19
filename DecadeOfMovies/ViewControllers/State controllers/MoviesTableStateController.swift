//
//  MoviesTableStateController.swift
//  DecadeOfMovies
//
//  Created by Yousef Hamza on 7/19/20.
//  Copyright © 2020 yousefahmza. All rights reserved.
//

import UIKit

enum MoviesTableStateControllerState {
    case normal
    case search
}

class MoviesTableStateController: DecadeOfMoviesStateController {
    var state: MoviesTableStateControllerState = .normal {
        didSet {
            updateForConfig()
        }
    }

    override init() {
        super.init()
        updateForConfig()
    }

    func updateForConfig() {
        let config = configuration
        switch state {
        case .normal:
            config.reloadButton.setTitle("Import Movies", for: .normal)
            config.emptyLabel.text = "There's no movies yet, import movies to see movies of the last decade"
        case .search:
            config.reloadButton.setTitle(nil, for: .normal)
            config.emptyLabel.text = "No movies are matching your search query"
        }
    }
}
