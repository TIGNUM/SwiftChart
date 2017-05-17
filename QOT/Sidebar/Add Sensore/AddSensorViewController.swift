//
//  AddSensorViewController.swift
//  QOT
//
//  Created by Sam Wyndham on 17.05.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

protocol AddSensorViewControllerDelegate: class {
    func didTapSensor(_ sensor: AddSensorViewModel.Sensor, in viewController: UIViewController)
}

final class AddSensorViewController: UIViewController {

    private let viewModel: AddSensorViewModel

    weak var delegate: AddSensorViewControllerDelegate?

    init(viewModel: AddSensorViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
