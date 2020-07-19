//
//  StateController.swift
//  DecadeOfMovies
//
//  Created by Yousef Hamza on 7/19/20.
//  Copyright © 2020 yousefahmza. All rights reserved.
//

import UIKit

open class StateController: StateElementDataSource {

    private var isLoading = false
    private var loadingError: StateError?=nil
    private var isEmpty = true
    open var configuration: StateConfiguration

    public init() {
        configuration = StateConfiguration()
        let reloadButton = UIButton()
        reloadButton.setTitle("Reload", for: .normal)
        configuration.reloadButton = reloadButton
        if #available(iOS 13.0, *) {
            let indicatorView = UIActivityIndicatorView(style: .medium)
            indicatorView.tintColor = .gray
            configuration.loadingView = indicatorView
        } else {
            configuration.loadingView = UIActivityIndicatorView(style: .gray)
        }
        configuration.loadingColor = .white
        configuration.emptyLabel = defaultLabel()
        configuration.errorLabel = defaultLabel()
    }

    func defaultLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "No records to show now, Please try again later."
        return label
    }

    public func startLoading() {
        isLoading = true
        loadingError = nil
        isEmpty = true
    }

    public func didLoad(count: Int) {
        isLoading = false
        loadingError = nil
        isEmpty = count == 0
    }

    open func didReceive(error: JoeError) {
        isLoading = false
        loadingError = error
        isEmpty = true
    }

    public func statefulViewIsEmpty(_ view: StatefulElement) -> Bool {
        return isEmpty
    }

    public func statefulViewIsLoading(_ view: StatefulElement) -> Bool {
        return isLoading
    }

    public func statefulViewError(_ view: StatefulElement) -> JoeError? {
        return loadingError
    }

    public func statefulViewIsCompact(_ view: StatefulElement) -> Bool {
        return false
    }

    public func statefulViewConfiguration(_ view: StatefulElement) -> StateConfiguration {
        return configuration
    }
}
