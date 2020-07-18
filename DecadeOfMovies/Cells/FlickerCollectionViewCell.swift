//
//  FlickerCollectionViewCell.swift
//  DecadeOfMovies
//
//  Created by Yousef Hamza on 7/18/20.
//  Copyright © 2020 yousefahmza. All rights reserved.
//

import UIKit

class FlickerCollectionViewCell: UICollectionViewCell {
    lazy var flickImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(flickImageView)
        setNeedsUpdateConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func updateConstraints() {
        NSLayoutConstraint.activate([
            flickImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            flickImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            flickImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            flickImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        super.updateConstraints()
    }
}
