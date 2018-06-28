//
//  ShareViewController.swift
//  QOT
//
//  Created by Sam Wyndham on 01/03/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit

final class ShareViewController: UIViewController, ShareViewControllerInterface {

    // MARK: - Properties

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var relationshipLabel: UILabel!
    @IBOutlet private weak var emailLabel: UILabel!
    @IBOutlet private weak var toBeVisionButton: UIButton!
    @IBOutlet private weak var weeklyChoicesButton: UIButton!
    @IBOutlet private weak var shareButton: UIButton!
    @IBOutlet private weak var partnerImageView: UIImageView!
    @IBOutlet private weak var toBeVisionButtonLabel: UILabel!
    @IBOutlet private weak var weeklyChoicesButtonLabel: UILabel!
    @IBOutlet private weak var partnerInitialsLabel: UILabel!
    @IBOutlet private var contentViews: [UIView]!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var interactor: ShareInteractorInterface?

    // MARK: - Init

    init(configure: Configurator<ShareViewController>) {
        super.init(nibName: nil, bundle: nil)
        configure(self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        contentViews.forEach { $0.backgroundColor = .clear   }
        toBeVisionButton.isSelected = true
        setupNavigationItems()
        setupShareButton()
        syncShareButton()
        interactor?.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        syncShareButton()
    }

    func setup(name: String, relationship: String, email: String) {
        nameLabel.text = name.uppercased()
        relationshipLabel.text = relationship.uppercased()
        emailLabel.text = email.uppercased()
    }

    func setPartnerProfileImage(_ imageURL: URL?, initials: String) {
        if imageURL != nil {
            partnerImageView.kf.setImage(with: imageURL)
        } else {
            partnerImageView.backgroundColor = UIColor.whiteLight
            partnerInitialsLabel.attributedText = NSAttributedString(
                string: initials.uppercased(),
                letterSpacing: 2,
                font: Font.H1MainTitle,
                lineSpacing: 0,
                textColor: .white60,
                alignment: .center
            )
        }
    }

    func setAvailableShareTypes(myToBeVision: Bool, weeklyChoice: Bool) {
        shareButton.isEnabled = (myToBeVision || weeklyChoice)
        if shareButton.isEnabled == false {
            shareButton.backgroundColor = .gray
        }

        toBeVisionButtonLabel.textColor = myToBeVision ? .white : .gray
        toBeVisionButton.isEnabled = myToBeVision
        toBeVisionButton.setTitleColor(.gray, for: .disabled)
        toBeVisionButton.isUserInteractionEnabled = myToBeVision

        weeklyChoicesButtonLabel.textColor = weeklyChoice ? .white : .gray
        weeklyChoicesButton.setTitleColor(.gray, for: .disabled)
        weeklyChoicesButton.isEnabled = weeklyChoice
        weeklyChoicesButton.isUserInteractionEnabled = weeklyChoice

        [toBeVisionButton, weeklyChoicesButton].compactMap { (button) -> UIButton? in
            button.isEnabled ? button : nil
        }.first?.isSelected = true
    }

    func setLoading(loading: Bool) {
        toBeVisionButton.isUserInteractionEnabled = !loading
        weeklyChoicesButton.isUserInteractionEnabled = !loading
        shareButton.isHidden = loading
        activityIndicator.isHidden = !loading
    }
}

// MARK: - Private

private extension ShareViewController {

    func setupNavigationItems() {
        let closeButton = UIBarButtonItem(withImage: R.image.ic_close())
        closeButton.target = self
        closeButton.action = #selector(didTapClose(_ :))
        navigationItem.leftBarButtonItem = closeButton
        let editButton = UIBarButtonItem(withImage: R.image.ic_edit())
        editButton.target = self
        editButton.action = #selector(didTapClose(_ :))
        navigationItem.leftBarButtonItem = closeButton
    }

    func setupShareButton() {
        shareButton.layer.cornerRadius = 20
    }

    private func syncShareButton() {
        shareButton.setTitleColor(.white, for: .normal)
    }
}

// MARK: - Actions

private extension ShareViewController {

    @objc func didTapClose(_ sender: UIBarButtonItem) {
        interactor?.didTapClose()
    }

    @IBAction func didTapOption(_ sender: UIButton) {
        guard sender.isSelected == false else { return }
        sender.isSelected = true
        var otherOptions = Set([toBeVisionButton, weeklyChoicesButton])
        otherOptions.remove(sender)
        otherOptions.forEach { $0.isSelected = false }
    }

    @IBAction func didTapShareButton(_ sender: UIButton) {
        if toBeVisionButton.isSelected == true {
            interactor?.didTapShareToBeVision()
        } else if weeklyChoicesButton.isSelected == true {
            interactor?.didTapShareWeeklyChoices()
        }
    }
}
