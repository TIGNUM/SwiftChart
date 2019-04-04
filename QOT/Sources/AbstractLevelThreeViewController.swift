//
//  AbstractLevelThreeViewController.swift
//  QOT
//
//  Created by karmic on 14.03.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

class AbstractLevelThreeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCloseButton()
    }
}

// MARK: - Actions

extension AbstractLevelThreeViewController {
    @objc func didTabClose() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Private

private extension AbstractLevelThreeViewController {
    func setupCloseButton() {
        let button = UIButton(type: .custom)
        let origin = CGPoint(x: 22, y: view.frame.size.height - 100)
        button.frame = CGRect(origin: origin, size: CGSize(width: 44, height: 44))
        button.backgroundColor = .gray
        let radius = button.bounds.width / 2
        button.corner(radius: radius)
        button.addTarget(self, action: #selector(didTabClose), for: .touchUpInside)
        view.addSubview(button)
    }
}
