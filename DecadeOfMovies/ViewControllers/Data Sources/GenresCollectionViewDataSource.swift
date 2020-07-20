//
//  GenresCollectionViewDataSource.swift
//  DecadeOfMovies
//
//  Created by Yousef Hamza on 7/20/20.
//  Copyright © 2020 yousefahmza. All rights reserved.
//

import UIKit

class GenresCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    let genres: [String]
    let reuseIdentifier: String

    init(genres: [String], reuseIdentifier: String) {
        self.genres = genres
        self.reuseIdentifier = reuseIdentifier
        super.init()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        genres.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! GenresCollectionViewCell

        let genre = genres[indexPath.item]
        cell.genre = genre as String
        cell.contentView.backgroundColor = .systemBlue

        return cell
    }
}
