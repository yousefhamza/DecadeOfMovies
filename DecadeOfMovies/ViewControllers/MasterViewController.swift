//
//  MasterViewController.swift
//  DecadeOfMovies
//
//  Created by Yousef Hamza on 7/16/20.
//  Copyright © 2020 yousefahmza. All rights reserved.
//

import UIKit

class MasterDetailViewController: UISplitViewController {
    init() {
        super.init(nibName: nil, bundle: nil)
        let masterTableViewController = UITableViewController(style: .plain)
        let viewController = ViewController()
        viewControllers = [
            UINavigationController(rootViewController: masterTableViewController),
            UINavigationController(rootViewController: viewController)
        ]
        delegate = self
        preferredDisplayMode = .automatic
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

extension MasterDetailViewController: UISplitViewControllerDelegate {
    public func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        // Return true on the inital view controller only, else return false
        guard let secondaryViewController = secondaryViewController as? UINavigationController else {
            return false
        }
        return secondaryViewController.topViewController?.isKind(of: ViewController.classForCoder()) ?? false
    }
}
