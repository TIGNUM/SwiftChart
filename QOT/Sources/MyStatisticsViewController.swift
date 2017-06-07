//
//  MyStatisticsViewController.swift
//  QOT
//
//  Created by karmic on 11.05.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

protocol MyStatisticsViewControllerDelegate: class {
    func didSelectStatitcsCard(in section: Index, at index: Index, from viewController: MyStatisticsViewController)
}

final class MyStatisticsViewController: UIViewController {

    // MARK: - Properties

    fileprivate let viewModel: MyStatisticsViewModel
    weak var delegate: MyStatisticsViewControllerDelegate?

    // MARK: - Init

    init(viewModel: MyStatisticsViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
