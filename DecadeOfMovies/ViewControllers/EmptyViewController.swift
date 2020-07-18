//
//  EmptyViewController.swift
//  DecadeOfMovies
//
//  Created by Yousef Hamza on 7/16/20.
//  Copyright © 2020 yousefahmza. All rights reserved.
//

import UIKit

class EmptyViewController: UIViewController {

    lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.text = "Choose a movie to be displayed here"
        label.font = UIFont.preferredFont(forTextStyle: .callout)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        view.addSubview(messageLabel)
        NSLayoutConstraint.activate([
            messageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}

