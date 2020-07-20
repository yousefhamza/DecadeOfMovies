//
//  FlickerImagesCollectionViewController.swift
//  DecadeOfMovies
//
//  Created by Yousef Hamza on 7/18/20.
//  Copyright © 2020 yousefahmza. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class FlickerImagesCollectionViewController: UIViewController {
    let collectionView: StatefulCollectionView
    let movieTitle: String
    let pagingController = PagingController()
    lazy var stateController = FlickerImagesStateController()
    var photos: [FlickerPhoto] = []

    init(movieTitle: String) {
        self.movieTitle = movieTitle
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.minimumLineSpacing = 10
        self.collectionView = StatefulCollectionView(frame: .zero, collectionViewLayout: flowLayout)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Flicker Images"
        view.addSubview(collectionView)
        collectionView.layoutFullyInSuperView()
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .always
        }
        collectionView.allowsSelection = false
        if #available(iOS 13.0, *) {
            collectionView.backgroundColor = .systemBackground
            view.backgroundColor = .systemBackground
        } else {
            collectionView.backgroundColor = .white
            view.backgroundColor = .white
        }
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.stateDataSource = stateController
        collectionView.stateDelegate = self

        // Register cell classes
        self.collectionView.register(FlickerCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

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
        let safeAreaInset: UIEdgeInsets
        if #available(iOS 11.0, *) {
            safeAreaInset = navigationController?.view.safeAreaInsets ?? .zero
        } else {
            safeAreaInset = .zero
        }
        let realWidth = width - (flowLayout?.minimumInteritemSpacing ?? CGFloat(0)) -
            sectionInset.right - sectionInset.left - safeAreaInset.right - safeAreaInset.left
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
        if pagingController.nextPageIndex == 1 {
            stateController.startLoading()
            collectionView.reloadData()
        }
        pagingController.startLoadingNextPage()
        Network.shared.executeRequest(at: EndPoint.images(movieTitle: movieTitle, page: pagingController.nextPageIndex),
                                      successCallback: { (res: FlickerResponse) in
                                        self.pagingController.loadedPage(loadedPageIndex: res.page, totalNumberOfPages: res.totalPages)

                                        let oldCount = self.photos.count
                                        self.photos += res.photos

                                        self.stateController.didLoad(count: self.photos.count)
                                        self.collectionView.reloadState()
                                        self.collectionView.performBatchUpdates({
                                            let newIP = (oldCount..<self.photos.count)
                                                .map({IndexPath(item: $0, section: 0)})
                                            self.collectionView
                                                .insertItems(at: newIP)
                                        }, completion: nil)
        },
                                      errorCallback: { (error) in
                                        self.pagingController.finishedWithError()
                                        self.stateController.didReceive(error: StateError(description: error.description))
                                        self.collectionView.reloadData()
        })
    }
}

extension FlickerImagesCollectionViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FlickerCollectionViewCell

        let photo = photos[indexPath.item]
        cell.flickImageView.setImage(url: EndPoint.flickPhoto(photo: photo).url,
                                     size: (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.itemSize)

        return cell
    }
}

extension FlickerImagesCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                                 willDisplay cell: UICollectionViewCell,
                                 forItemAt indexPath: IndexPath) {
        guard indexPath.item == photos.count - 1 else {
            return
        }
        fetchImages()
    }
}

extension FlickerImagesCollectionViewController: StateElementDelegate {
    func statefulElementDidTapReload() {
        fetchImages()
    }
}
