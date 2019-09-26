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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let indexPath = selectedIndexPath {
            tableView.deselectRow(at: indexPath, animated: true)
            selectedIndexPath = nil
        }
    }

    func didSelectRow(at indexPath: IndexPath) {
        selectedIndexPath = indexPath
        tableView.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
            self.tableView.isUserInteractionEnabled = true
        }
    }
}

class BaseWithGroupedTableViewController: BaseViewController {

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
