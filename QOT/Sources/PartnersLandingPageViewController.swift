//
//  PartnersLandingPageViewController.swift
//  QOT
//
//  Created by karmic on 09.05.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit

final class PartnersLandingPageViewController: PartnersAnimationViewController {

    // MARK: - Properties

    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var headlineLabel: UILabel!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var addButton: UIButton!
    var interactor: PartnersLandingPageInteractorInterface?

    // MARK: - Init

    init(configure: Configurator<PartnersLandingPageViewController>) {
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

private extension PartnersLandingPageViewController {

    func setupView(partnersLandingPage: PartnersLandingPage) {
        setupNavigationItems()
        setupProfileImageView(image: partnersLandingPage.defaultProfilePicture)
        setupLabels(title: partnersLandingPage.titleAttributedString,
                    message: partnersLandingPage.messageAttributedString)
        setupAddButton(buttonTitle: partnersLandingPage.buttonTitleAttributedString)
    }

    func setupNavigationItems() {
        let leftButton = UIBarButtonItem(withImage: R.image.ic_minimize())
        leftButton.target = self
        leftButton.action = #selector(didTapClose)
        navigationItem.leftBarButtonItem = leftButton
    }

    func setupProfileImageView(image: UIImage?) {
        profileImageView.image = image
    }

    func setupLabels(title: NSAttributedString, message: NSAttributedString) {
        headlineLabel.attributedText = title
        messageLabel.attributedText = message
    }

    func setupAddButton(buttonTitle: NSAttributedString) {
        addButton.layer.cornerRadius = 8
        addButton.backgroundColor = .azure
        addButton.setAttributedTitle(buttonTitle, for: .normal)
        addButton.setAttributedTitle(buttonTitle, for: .selected)
    }
}

// MARK: - Actions

private extension PartnersLandingPageViewController {

    @IBAction func didTapAddPartnerButton() {
        interactor?.presentPartnersController()
    }

    @objc func didTapClose() {
        interactor?.didTapClose()
    }
}

// MARK: - PartnersLandingPageViewControllerInterface

extension PartnersLandingPageViewController: PartnersLandingPageViewControllerInterface {

    func dismiss() {
        dismiss(animated: true, completion: nil)
    }

    func setup(partnersLandingPage: PartnersLandingPage) {
        setupView(partnersLandingPage: partnersLandingPage)
    }
}
