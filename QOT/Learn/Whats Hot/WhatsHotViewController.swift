//
//  WhatsHotViewController.swift
//  QOT
//
//  Created by karmic on 30/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

protocol WhatsHotViewControllerDelegate: class {
    func didTapVideo(at index: Index, with localID: String, from view: UIView, in viewController: WhatsHotViewController)
    func didTapBookmark(at index: Index, with whatsHot: WhatsHotItem, in view: UIView, in viewController: WhatsHotViewController)
}

class WhatsHotViewController: UITableViewController {

    // MARK: - Properties

    let viewModel: WhatsHotViewModel
    weak var delegate: WhatsHotViewControllerDelegate?

    // MARK: - Life Cycle

    init(viewModel: WhatsHotViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black
    }
}
