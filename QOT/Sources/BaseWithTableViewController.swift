//
//  BaseWithTableViewController.swift
//  QOT
//
//  Created by Dominic Frazer Imregh on 11/09/2019.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

class BaseWithTableViewController: BaseViewController {

    private var selectedIndexPath: IndexPath?
    @IBOutlet weak var tableView: UITableView!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.isUserInteractionEnabled = true
    }

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

    func didDeselectRow(at indexPath: IndexPath) {
        selectedIndexPath = nil
    }
}

class BaseWithGroupedTableViewController: BaseViewController {

    private var selectedIndexPath: IndexPath?
    lazy var tableView: UITableView = {
        return UITableView(frame: .zero, style: .grouped)
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.isUserInteractionEnabled = true
    }

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

    func didDeselectRow(at indexPath: IndexPath) {
        selectedIndexPath = nil
    }
}
