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
    let pagingController = PagingController()
    var photos: [FlickerPhoto] = []

    init(movieTitle: String) {
        self.movieTitle = movieTitle
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.minimumLineSpacing = 10
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
        self.collectionView!.register(FlickerCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

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
        guard pagingController.shouldLoadNextPage else {
            return
        }
        pagingController.startLoadingNextPage()
        Network.shared.executeRequest(at: EndPoint.images(movieTitle: movieTitle, page: pagingController.nextPageIndex),
                                      successCallback: { (res: FlickerResponse) in
                                        self.pagingController.loadedPage(loadedPageIndex: res.page, totalNumberOfPages: res.totalPages)
                                        self.photos += res.photos
                                        self.collectionView.performBatchUpdates({
                                            self.collectionView
                                                .insertItems(at: (0..<res.pageSize)
                                                    .map({IndexPath(item: $0 + self.photos.count - res.pageSize,
                                                        section: 0)}))
                                        }, completion: nil)
        },
                                      errorCallback: { (error) in
                                        print("error")
                                        // TODO: Handle error
        })
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FlickerCollectionViewCell

        let photo = photos[indexPath.item]
        cell.flickImageView.setImage(url: EndPoint.flickPhoto(photo: photo).url,
                                     size: (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.itemSize)
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView,
                                 willDisplay cell: UICollectionViewCell,
                                 forItemAt indexPath: IndexPath) {
        guard indexPath.item == photos.count - 1 else {
            return
        }
        fetchImages()
    }
}
