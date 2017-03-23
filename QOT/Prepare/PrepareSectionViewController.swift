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
    
    weak var delegate: PrepareSectionDelegate?
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .green
    }
}
