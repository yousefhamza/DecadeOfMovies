//
//  RemoveImageView.swift
//  DecadeOfMovies
//
//  Created by Yousef Hamza on 7/18/20.
//  Copyright © 2020 yousefahmza. All rights reserved.
//

import UIKit
import Kingfisher

class RemoveImageView: UIImageView {
    var indexPath: IndexPath?=nil

    func setImage(url: URL, at indexPath: IndexPath, size: CGSize?) {
        self.indexPath = indexPath
        let processor = DownsamplingImageProcessor(size: size ?? .zero)
        kf.indicatorType = .activity
        kf.setImage(
            with: url,
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
        {
            [weak self] result in
            switch result {
            case .success(let value):
                if indexPath == self?.indexPath {
                    self?.image = value.image
                }
            case .failure(let error):
                print("error: \(error.localizedDescription)")
            }
        }
    }
}
