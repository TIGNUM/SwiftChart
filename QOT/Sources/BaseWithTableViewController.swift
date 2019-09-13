//
//  BaseWithTableViewController.swift
//  QOT
//
//  Created by Dominic Frazer Imregh on 11/09/2019.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

class BaseWithTableViewController: UIViewController {

    private var selectedIndexPath: IndexPath?
    @IBOutlet weak var tableView: UITableView!

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let indexPath = selectedIndexPath {
            tableView.deselectRow(at: indexPath, animated: true)
            selectedIndexPath = nil
        }
    }

    func didSelectRow(at indexPath: IndexPath) {
        selectedIndexPath = indexPath
    }
}

class BaseWithGroupedTableViewController: UIViewController {

    private var selectedIndexPath: IndexPath?
    lazy var tableView: UITableView = {
        return UITableView(frame: .zero, style: .grouped)
    }()

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let indexPath = selectedIndexPath {
            tableView.deselectRow(at: indexPath, animated: true)
            selectedIndexPath = nil
        }
    }

    func didSelectRow(at indexPath: IndexPath) {
        selectedIndexPath = indexPath
    }
}
