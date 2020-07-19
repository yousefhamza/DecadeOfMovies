//
//  FlickerImagesStateController.swift
//  DecadeOfMovies
//
//  Created by Yousef Hamza on 7/19/20.
//  Copyright © 2020 yousefahmza. All rights reserved.
//

import UIKit

class FlickerImagesStateController: DecadeOfMoviesStateController {
    override init() {
        super.init()
        configuration.emptyLabel.text = "No images to show"
        configuration.reloadButton.setTitle("Reload", for: .normal)
    }
}
