//
//  DecadeOfMoviesStateController.swift
//  DecadeOfMovies
//
//  Created by Yousef Hamza on 7/19/20.
//  Copyright © 2020 yousefahmza. All rights reserved.
//

import UIKit

class DecadeOfMoviesStateController: StateController {
    override init() {
        super.init()
        configuration.emptyLabel.font = UIFont.preferredFont(forTextStyle: .callout)
        configuration.errorLabel.font = UIFont.preferredFont(forTextStyle: .callout)
        if #available(iOS 13.0, *) {
            configuration.emptyLabel.textColor = .secondaryLabel
            configuration.errorLabel.textColor = .secondaryLabel
        } else {
            configuration.emptyLabel.textColor = .darkGray
            configuration.errorLabel.textColor = .darkGray
        }
        if #available(iOS 13.0, *) {
            configuration.loadingView.color = .systemFill
        } else {
            configuration.loadingView.color = .darkGray
        }
    }
}
