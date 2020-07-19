//
//  StatefulList.swift
//  DecadeOfMovies
//
//  Created by Yousef Hamza on 7/19/20.
//  Copyright © 2020 yousefahmza. All rights reserved.
//

import UIKit

open class StateConfiguration {
    public var reloadButton: UIButton!
    public var loadingView: UIView!
    public var loadingColor: UIColor!
    public var emptyImage: UIImage!
    public var errorImage: UIImage!
    public var emptyLabel: UILabel!
    public var errorLabel: UILabel!
}

public struct StateError: Error {
    let title: String?
    let description: String
}

public protocol StatefulElement: class {
    var backgroundView: UIView? { get set }
    var stateDataSource: StateElementDataSource? { get set }
    var stateDelegate: StateElementDelegate? { get set }
    func reloadState()
}

public protocol StateElementDataSource {
    func statefulViewIsEmpty(_ view: StatefulElement) -> Bool
    func statefulViewIsLoading(_ view: StatefulElement) -> Bool
    func statefulViewError(_ view: StatefulElement) -> StateError?
    func statefulViewIsCompact(_ view: StatefulElement) -> Bool
    func statefulViewConfiguration(_ view: StatefulElement) -> StateConfiguration
}

public protocol StateElementDelegate {
    func statefulElementDidTapReload()
}

extension StatefulElement {
    public func reloadState() {
        guard let dataSource = stateDataSource else {
            return
        }

        let isCompact = dataSource.statefulViewIsCompact(self)

        if dataSource.statefulViewIsEmpty(self) == false {
            showContent()
            return
        }

        if let error = dataSource.statefulViewError(self) {
            showError(error, isCompact: isCompact)
            return
        }

        if dataSource.statefulViewIsLoading(self) {
            showLoading()
            return
        }

        showEmpty(isCompact: isCompact)
    }

    func showLoading() {
        print("Show loading")
        let config = stateDataSource!.statefulViewConfiguration(self)
        backgroundView = config.loadingView
    }

    func showError(_ error: StateError, isCompact: Bool) {
        print("Show error: \(error)")
        let config = stateDataSource!.statefulViewConfiguration(self)
        let errorLabel = config.errorLabel
        errorLabel?.text = "\(error.title ?? "Something wrong happened"): \(error.description)"
        backgroundView = StateView(image: config.errorImage,
                                   messageLabel: config.errorLabel,
                                   reloadButton: config.reloadButton,
                                   delegate: stateDelegate,
                                   isCompact: isCompact)
    }

    func showEmpty(isCompact: Bool) {
        print("Show Empty")
        let config = stateDataSource!.statefulViewConfiguration(self)
        let emptyLabel = config.emptyLabel
        if emptyLabel?.text == nil {
            emptyLabel?.text = "No records to show now, Please try again later."
        }
        backgroundView = StateView(image: config.emptyImage,
                                   messageLabel: config.emptyLabel,
                                   reloadButton: config.reloadButton,
                                   delegate: stateDelegate,
                                   isCompact: isCompact)
    }

    func showContent() {
        print("Show content")
        backgroundView = nil
    }
}

open class StatefulTableView: UITableView {
    public var stateDataSource: StateElementDataSource?
    public var stateDelegate: StateElementDelegate?

    fileprivate func addRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: UIControl.Event.valueChanged)
        if #available(iOS 10.0, *) {
            self.refreshControl = refreshControl
        }
    }

    convenience init() {
        self.init(frame: .zero, style: .grouped)
        addRefreshControl()
        contentInset = UIEdgeInsets(top: -30, left: 0, bottom: 0, right: 0)
    }

    override required public init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        addRefreshControl()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    open override func reloadData() {
        super.reloadData()
        reloadState()
    }

    @objc func refresh(_ sender: Any) {
        stateDelegate?.statefulElementDidTapReload()
        if #available(iOS 10.0, *) {
            refreshControl?.endRefreshing()
        }
    }
}

public class StatefulCollectionView: UICollectionView {
    public var stateDataSource: StateElementDataSource?
    public var stateDelegate: StateElementDelegate?

    fileprivate func addRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: UIControl.Event.valueChanged)
        if #available(iOS 10.0, *) {
            self.refreshControl = refreshControl
        }
    }

//    public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
//        super.init(frame: frame, collectionViewLayout: layout)
//
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }

    public override func reloadData() {
        super.reloadData()
        reloadState()
    }

    @objc func refresh(_ sender: Any) {
        stateDelegate?.statefulElementDidTapReload()
        if #available(iOS 10.0, *) {
            refreshControl?.endRefreshing()
        }
    }
}

extension StatefulTableView: StatefulElement {}
extension StatefulCollectionView: StatefulElement {}

