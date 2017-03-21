//
//  MainMenuViewController.swift
//  QOT
//
//  Created by Sam Wyndham on 13/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

protocol MainMenuViewControllerDelegate: class {
    func didTapLearn(in viewController: MainMenuViewController)
    func didTapMe(in viewController: MainMenuViewController)
    func didTapPrepare(in viewController: MainMenuViewController)
    func didTapSettingsButton(in viewController: MainMenuViewController)
}

class MainMenuViewController: UIViewController {
    weak var delegate: MainMenuViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapLearn() {
        delegate?.didTapLearn(in: self)
    }
    
    @IBAction func didTapMe() {
        delegate?.didTapMe(in: self)
    }
    
    @IBAction func didTapPrepare() {
        delegate?.didTapMe(in: self)
    }
    
    @IBAction func didTapSettingsButton() {
        delegate?.didTapSettingsButton(in:self)
    }
}
