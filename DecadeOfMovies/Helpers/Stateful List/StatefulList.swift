//
//  StatefulList.swift
//  DecadeOfMovies
//
//  Created by Yousef Hamza on 7/19/20.
//  Copyright © 2020 yousefahmza. All rights reserved.
//

import UIKit

/// Configuration for StateulElements
open class StateConfiguration {
    /// The reload button that shows in case of error or empty
    public var reloadButton: UIButton!

    /// The loading views that it's showed in the loading state
    public var loadingView: UIActivityIndicatorView!

    /// The empty image to show in case of empty list
    public var emptyImage: UIImage?

    /// The error image to show in case of error
    public var errorImage: UIImage?

    /// The label to show in case of empty list
    public var emptyLabel: UILabel!

    /// The error label to show in case of error
    public var errorLabel: UILabel!
}

public struct StateError: Error {
    let title: String?=nil
    let description: String
}

/// Stateful element is a view that that you want to support loading, empty and error states in
public protocol StatefulElement: class {
    var backgroundView: UIView? { get set }
    var stateDataSource: StateElementDataSource? { get set }
    var stateDelegate: StateElementDelegate? { get set }
    func reloadState()
}

/// DataSource provide the info needed in order for the StatefulElement to work
public protocol StateElementDataSource {
    /// Return if stateful element is empty
    /// - Parameter view: stateful element view
    func statefulViewIsEmpty(_ view: StatefulElement) -> Bool

    /// Return if stateful element is loading
    /// - Parameter view: stateful element view
    func statefulViewIsLoading(_ view: StatefulElement) -> Bool

    /// Return error if stateful element state is error
    /// - Parameter view: stateful element view
    func statefulViewError(_ view: StatefulElement) -> StateError?

    /// Returns is view is compact
    /// - Parameter view: stateful element view
    func statefulViewIsCompact(_ view: StatefulElement) -> Bool

    /// Return configuration to configure state view
    /// - Parameter view: stateful element view
    func statefulViewConfiguration(_ view: StatefulElement) -> StateConfiguration
}

public protocol StateElementDelegate {
    /// The action to be executed when the reload button is shown in the empty or error states
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

