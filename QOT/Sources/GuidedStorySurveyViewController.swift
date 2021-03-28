//
//  GuidedStorySurveyViewController.swift
//  QOT
//
//  Created by karmic on 26.03.21.
//  Copyright © 2021 Tignum. All rights reserved.
//

import UIKit

final class GuidedStorySurveyViewController: UIViewController {

    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - UITableViewDelegate
extension GuidedStorySurveyViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

// MARK: - UITableViewDataSource
extension GuidedStorySurveyViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
