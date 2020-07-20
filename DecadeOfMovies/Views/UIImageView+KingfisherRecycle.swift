//
//  RemoveImageView.swift
//  DecadeOfMovies
//
//  Created by Yousef Hamza on 7/18/20.
//  Copyright © 2020 yousefahmza. All rights reserved.
//

import UIKit
import Kingfisher

extension UIImageView {

    /// Set image by URL asyncrhonsly in image view, with keep a reference to indexpath of the cell
    /// that the image view belongs to, to prevent data races to the same image view while user
    /// is scrolling
    /// - Parameters:
    ///   - url: URL of the image to be loaded and added to the image view
    ///   - indexPath: Indexpath of the cell that carries the image view
    ///   - size: size of the cell for down sampling the image
    func setImage(url: URL, size: CGSize?) {
        kf.cancelDownloadTask()
        kf.indicatorType = .activity
        image = nil
        kf.setImage(
            with: url,
            options: [
                .transition(.fade(0.1)),
                .cacheOriginalImage
            ])
    }
}
