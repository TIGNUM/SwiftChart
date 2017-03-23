//
//  PrepareSectionViewController.swift
//  QOT
//
//  Created by karmic on 22/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Foundation

class PrepareSectionViewController: UIViewController {
    
    // MARK: - Properties
    let viewModel: PrepareChatBotViewModel
    fileprivate var tableView: UITableView?
    weak var delegate: PrepareChatBotDelegate?
    
    // MARK: - Life Cycle

    init(viewModel: PrepareChatBotViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .green
    }
}

extension PrepareSectionViewController {

    fileprivate func setupCollectionView() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView?.delegate = self
        tableView?.dataSource = self
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension PrepareSectionViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.messageCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let settingsCell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.settingsTableViewCell_Id.identifier, for: indexPath) as? SettingsTableViewCell else {
            return UITableViewCell()
        }

        settingsCell.setup()

        return settingsCell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
