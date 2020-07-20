//
//  MovieDetailView.swift
//  DecadeOfMovies
//
//  Created by Yousef Hamza on 7/18/20.
//  Copyright © 2020 yousefahmza. All rights reserved.
//

import UIKit

protocol MovieViewDelegate: AnyObject {
    func moviesViewDidSelectImages(_ moviesView: MovieDetailView)
}

class MovieDetailView: UIView, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    weak var delegate: MovieViewDelegate?

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

    private lazy var lineView: UIView = {
        let view = UIView()
        if #available(iOS 13.0, *) {
            view.backgroundColor = .secondarySystemFill
        } else {
            view.backgroundColor = .darkGray
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var genresLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.text = "Genres"
        if #available(iOS 13.0, *) {
            label.textColor = .label
        }
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var genresCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = 8
        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        flowLayout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.contentInset = .zero
        collectionView.allowsSelection = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    private lazy var castLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.text = "Cast"
        if #available(iOS 13.0, *) {
            label.textColor = .label
        }
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var castTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundView = nil
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.bounces = false
        tableView.contentInset = UIEdgeInsets(top: -30, left: 0, bottom: 0, right: 0)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 35
        return tableView
    }()

    private lazy var buttonsStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalCentering
        stackView.spacing = 8
        stackView.setContentHuggingPriority(.required, for: .vertical)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var imagesButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Show images from Flicker", for: .normal)
        button.setContentHuggingPriority(.required, for: .vertical)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    init() {
        super.init(frame: .zero)

        if #available(iOS 13.0, *) {
            backgroundColor = .systemBackground
            genresCollectionView.backgroundColor = .systemBackground
            castTableView.backgroundColor = .systemBackground
        } else {
            backgroundColor = .white
            genresCollectionView.backgroundColor = .white
            castTableView.backgroundColor = .white
        }
        addSubview(titleLabel)
        addSubview(yearLabel)
        addSubview(lineView)
        addSubview(genresLabel)
        addSubview(genresCollectionView)
        addSubview(castLabel)
        addSubview(castTableView)
        buttonsStack.addArrangedSubview(imagesButton)
        addSubview(buttonsStack)

        imagesButton.addTarget(self, action: #selector(didTapImages), for: .touchUpInside)

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
            titleLabel.leadingAnchor.constraint(equalTo: viewLayoutGuide.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: viewLayoutGuide.topAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: viewLayoutGuide.trailingAnchor, constant: -8),

            yearLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            yearLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            yearLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),

            lineView.leadingAnchor.constraint(equalTo: leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: trailingAnchor),
            lineView.heightAnchor.constraint(equalToConstant: 1),
            lineView.topAnchor.constraint(equalTo: yearLabel.bottomAnchor, constant: 4),

            genresLabel.leadingAnchor.constraint(equalTo: yearLabel.leadingAnchor),
            genresLabel.trailingAnchor.constraint(equalTo: yearLabel.trailingAnchor),
            genresLabel.topAnchor.constraint(equalTo: lineView.bottomAnchor, constant: 16),

            genresCollectionView.leadingAnchor.constraint(equalTo: genresLabel.leadingAnchor),
            genresCollectionView.trailingAnchor.constraint(equalTo: genresLabel.trailingAnchor),
            genresCollectionView.topAnchor.constraint(equalTo: genresLabel.bottomAnchor),
            genresCollectionView.heightAnchor.constraint(equalToConstant: 50),

            castLabel.leadingAnchor.constraint(equalTo: genresLabel.leadingAnchor),
            castLabel.trailingAnchor.constraint(equalTo: genresLabel.trailingAnchor),
            castLabel.topAnchor.constraint(equalTo: genresCollectionView.bottomAnchor, constant: 4),

            castTableView.leadingAnchor.constraint(equalTo: castLabel.leadingAnchor),
            castTableView.trailingAnchor.constraint(equalTo: castLabel.trailingAnchor),
            castTableView.topAnchor.constraint(equalTo: castLabel.bottomAnchor, constant: 4),
//            castTableView.heightAnchor.constraint(equalToConstant: 100),

            buttonsStack.leadingAnchor.constraint(equalTo: genresCollectionView.leadingAnchor),
            buttonsStack.trailingAnchor.constraint(equalTo: genresCollectionView.trailingAnchor),
            buttonsStack.topAnchor.constraint(equalTo: castTableView.bottomAnchor, constant: 16),
            buttonsStack.bottomAnchor.constraint(equalTo: viewLayoutGuide.bottomAnchor, constant: -4)
        ])
        super.updateConstraints()
    }

    func show(movie: MovieMO) {
        titleLabel.text = movie.title
        yearLabel.text = "\(movie.year)"
    }

    @objc private func didTapImages() {
        delegate?.moviesViewDidSelectImages(self)
    }
}
