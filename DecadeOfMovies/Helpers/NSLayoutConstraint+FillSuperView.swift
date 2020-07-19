//
//  NSLayoutConstraint+FillSuperView.swift
//  DecadeOfMovies
//
//  Created by Yousef Hamza on 7/19/20.
//  Copyright © 2020 yousefahmza. All rights reserved.
//

import UIKit

extension UIView {
    func layoutFullyInSuperView() {
        guard let currentSuperView = self.superview else {
            return
        }
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: currentSuperView.leadingAnchor),
            trailingAnchor.constraint(equalTo: currentSuperView.trailingAnchor),
            topAnchor.constraint(equalTo: currentSuperView.topAnchor),
            bottomAnchor.constraint(equalTo: currentSuperView.bottomAnchor)
        ])
    }
}
