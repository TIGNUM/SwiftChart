//
//  ConfirmationViewController.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 09.05.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class ConfirmationViewController: UIViewController {

    // MARK: - Properties

    var interactor: ConfirmationInteractorInterface?
    private var confirmationModel: ConfirmationModel?
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var rightButton: UIButton!
    @IBOutlet private weak var leftButton: UIButton!
    @IBOutlet private weak var visualEffectView: UIVisualEffectView!

    // MARK: - Init

    init(configure: Configurator<ConfirmationViewController>) {
        super.init(nibName: nil, bundle: nil)
        configure(self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.viewDidLoad()
        setupViews()
        fillViews()
    }
}

// MARK: - Actions

private extension ConfirmationViewController {

    @IBAction func didTapRight(_ sender: UIButton) {
        guard let buttonType = confirmationModel?.buttons[0].type else { return }
        interactor?.didTap(buttonType)
    }

    @IBAction func didTapLeft(_ sender: UIButton) {
        guard let buttonType = confirmationModel?.buttons[1].type else { return }
        interactor?.didTap(buttonType)
    }
}

// MARK: - ConfirmationViewControllerInterface

extension ConfirmationViewController: ConfirmationViewControllerInterface {

    func load(_ confirmationModel: ConfirmationModel) {
        self.confirmationModel = confirmationModel
    }
}

// MARK: - Private

extension ConfirmationViewController {

    func setupViews() {
        view.backgroundColor = .clear
        leftButton.layer.borderWidth = 1
        rightButton.layer.borderWidth = 1
        leftButton.layer.borderColor = UIColor.accent30.cgColor
        rightButton.layer.borderColor = UIColor.accent30.cgColor
        leftButton.corner(radius: leftButton.bounds.height / 2)
        rightButton.corner(radius: rightButton.bounds.height / 2)
    }

    func fillViews() {
        descriptionLabel.text = confirmationModel?.description
        titleLabel.text = confirmationModel?.title.uppercased()
        rightButton.setTitle(confirmationModel?.buttons[0].title, for: .normal)
        leftButton.setTitle(confirmationModel?.buttons[1].title, for: .normal)
    }
}
