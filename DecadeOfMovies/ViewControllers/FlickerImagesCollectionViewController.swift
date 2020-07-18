//
//  FlickerImagesCollectionViewController.swift
//  DecadeOfMovies
//
//  Created by Yousef Hamza on 7/18/20.
//  Copyright © 2020 yousefahmza. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class FlickerImagesCollectionViewController: UICollectionViewController {
    let movieTitle: String
    let currentPage: Int = 1

    init(movieTitle: String) {
        self.movieTitle = movieTitle
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        flowLayout.minimumInteritemSpacing = 5
        flowLayout.minimumLineSpacing = 5
        super.init(collectionViewLayout: flowLayout)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Flicker Images"
        collectionView.allowsSelection = false
        if #available(iOS 13.0, *) {
            collectionView.backgroundColor = .systemBackground
        } else {
            collectionView.backgroundColor = .white
        }

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        fetchImages()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        updateItemSize()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        DispatchQueue.main.async {
            self.updateItemSize()
        }
    }

    private func updateItemSize() {
        let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        let width = view.bounds.width
        print("view width: \(width), nav width: \(navigationController?.view.bounds.width ?? 0)")
        let sectionInset = flowLayout?.sectionInset ?? .zero
        let realWidth = width - (flowLayout?.minimumInteritemSpacing ?? CGFloat(0)) - sectionInset.right - sectionInset.left
        let itemSizeLength = realWidth / 2

        guard itemSizeLength != 0 || itemSizeLength == flowLayout?.itemSize.width ?? 0 else {
            return
        }
        flowLayout?.itemSize = CGSize(width: itemSizeLength, height: itemSizeLength)
        flowLayout?.invalidateLayout()
    }

    func fetchImages() {
        Network.shared.executeRequest(at: .images(movieTitle: movieTitle, page: currentPage),
                                      successCallback: { (res: FlickerResponse) in
                                        print("success: \(res.photos.count)")
        },
                                      errorCallback: { (error) in
                                        print("error")
                                        // TODO: Handle error
        })
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 5
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        cell.contentView.backgroundColor = .gray
    
        return cell
    }
}
