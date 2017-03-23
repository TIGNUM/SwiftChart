//
//  PrepareSectionViewController.swift
//  QOT
//
//  Created by karmic on 22/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

class PrepareSectionViewController: UIViewController {
    
    // MARK: - Properties
    let viewModel: PrepareChatBotViewModel
    weak var delegate: PrepareSectionDelegate?
    
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
