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

    /// Set image by URL asyncrhonsly in image view, with keep a reference to indexpath of the cell
    /// that the image view belongs to, to prevent data races to the same image view while user
    /// is scrolling
    /// - Parameters:
    ///   - url: URL of the image to be loaded and added to the image view
    ///   - indexPath: Indexpath of the cell that carries the image view
    ///   - size: size of the cell for down sampling the image
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
