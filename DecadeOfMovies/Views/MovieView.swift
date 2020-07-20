//
//  MovieView.swift
//  DecadeOfMovies
//
//  Created by Yousef Hamza on 7/18/20.
//  Copyright © 2020 yousefahmza. All rights reserved.
//

import UIKit

protocol MovieViewDelegate: AnyObject {
    func movieViewDidSelectGenres(_ moviesView: MovieView)
    func movieViewDidSelectCast(_ moviesView: MovieView)
    func moviesViewDidSelectImages(_ moviesView: MovieView)
}

class MovieView: UIView, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
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
            genresCollectionView.backgroundColor = .systemBackground
        } else {
            backgroundColor = .white
            genresCollectionView.backgroundColor = .white
        }
        addSubview(titleLabel)
        addSubview(yearLabel)
        addSubview(lineView)
        addSubview(genresLabel)
        addSubview(genresCollectionView)
        buttonsStack.addArrangedSubview(genresButton)
        buttonsStack.addArrangedSubview(castButton)
        buttonsStack.addArrangedSubview(imagesButton)
        addSubview(buttonsStack)

        genresButton.addTarget(self, action: #selector(didTapGenres), for: .touchUpInside)
        castButton.addTarget(self, action: #selector(didTapCast), for: .touchUpInside)
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
            titleLabel.leadingAnchor.constraint(equalTo: viewLayoutGuide.leadingAnchor, constant: 8),
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

            buttonsStack.leadingAnchor.constraint(equalTo: genresCollectionView.leadingAnchor),
            buttonsStack.trailingAnchor.constraint(equalTo: genresCollectionView.trailingAnchor),
            buttonsStack.topAnchor.constraint(equalTo: genresCollectionView.bottomAnchor, constant: 16),
            buttonsStack.bottomAnchor.constraint(lessThanOrEqualTo: viewLayoutGuide.bottomAnchor, constant: -16)
        ])
        super.updateConstraints()
    }

    func show(movie: MovieMO) {
        titleLabel.text = movie.title
        yearLabel.text = "\(movie.year)"
    }

    @objc private func didTapGenres() {
        delegate?.movieViewDidSelectGenres(self)
    }

    @objc private func didTapCast() {
        delegate?.movieViewDidSelectCast(self)
    }

    @objc private func didTapImages() {
        delegate?.moviesViewDidSelectImages(self)
    }
}
