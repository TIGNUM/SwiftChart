//
//  CoachViewController.swift
//  QOT
//
//  Created by karmic on 14.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class CoachViewController: UIViewController {

    // MARK: - Properties

    var interactor: CoachInteractorInterface?

    // MARK: - Init

    init(configure: Configurator<CoachViewController>) {
        super.init(nibName: nil, bundle: nil)
        configure(self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.viewDidLoad()
    }
}

// MARK: - Private

private extension CoachViewController {
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

// MARK: - Actions

private extension CoachViewController {
    @objc func didTabClose() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - CoachViewControllerInterface

extension CoachViewController: CoachViewControllerInterface {
    func setupView() {
        view.backgroundColor = .yellow
        setupCloseButton()
    }
}
