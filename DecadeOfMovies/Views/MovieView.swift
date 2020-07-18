//
//  MovieView.swift
//  DecadeOfMovies
//
//  Created by Yousef Hamza on 7/18/20.
//  Copyright © 2020 yousefahmza. All rights reserved.
//

import UIKit

class MovieView: UIView {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        if #available(iOS 13.0, *) {
            label.textColor = .label
        }
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var yearLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        if #available(iOS 13.0, *) {
            label.textColor = .secondaryLabel
        }
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var buttonsStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalCentering
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var genresButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Show genres", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var castButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Show cast", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var imagesButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Show images from Flicker", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    init() {
        super.init(frame: .zero)

        if #available(iOS 13.0, *) {
            backgroundColor = .systemBackground
        } else {
            backgroundColor = .white
        }
        addSubview(titleLabel)
        addSubview(yearLabel)
        buttonsStack.addArrangedSubview(genresButton)
        buttonsStack.addArrangedSubview(castButton)
        buttonsStack.addArrangedSubview(imagesButton)
        addSubview(buttonsStack)

        setNeedsUpdateConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func updateConstraints() {
        let viewLayoutGuide: LegacyLayoutGuide!
        if #available(iOS 11.0, *) {
            viewLayoutGuide = safeAreaLayoutGuide
        } else {
            viewLayoutGuide = self
        }

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: viewLayoutGuide.leadingAnchor, constant: 8),
            titleLabel.topAnchor.constraint(equalTo: viewLayoutGuide.topAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: viewLayoutGuide.trailingAnchor, constant: -8),

            yearLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            yearLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            yearLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),

            buttonsStack.leadingAnchor.constraint(equalTo: yearLabel.leadingAnchor),
            buttonsStack.trailingAnchor.constraint(equalTo: yearLabel.trailingAnchor),
            buttonsStack.topAnchor.constraint(equalTo: yearLabel.bottomAnchor, constant: 16),
            buttonsStack.bottomAnchor.constraint(lessThanOrEqualTo: viewLayoutGuide.bottomAnchor, constant: -16)
        ])
        super.updateConstraints()
    }

    func show(movie: MovieMO) {
        titleLabel.text = movie.title
        yearLabel.text = "\(movie.year)"
    }
}
