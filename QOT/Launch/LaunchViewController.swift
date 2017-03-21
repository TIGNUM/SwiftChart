//
//  LaunchViewController.swift
//  QOT
//
//  Created by Sam Wyndham on 10/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Bond

protocol LaunchViewControllerDelegate: class {
    func didTapLaunchViewController(_ viewController: LaunchViewController)
    func didTapSettingsButton(in viewController: LaunchViewController)
}

final class LaunchViewController: UIViewController {
    let viewModel: LaunchViewModel
    
    @IBOutlet weak var tapGestureRecognizer: UITapGestureRecognizer!
    
    weak var delegate: LaunchViewControllerDelegate?
    
    init(viewModel: LaunchViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() { 
        super.viewDidLoad()

        viewModel.ready.bind(to: tapGestureRecognizer.reactive.isEnabled)
    }
    
    @IBAction func didTap() {
        delegate?.didTapLaunchViewController(self)
    }
    
    @IBAction func didTapSettingsButton() {
        delegate?.didTapSettingsButton(in:self)
    }
}
