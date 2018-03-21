//
//  ShareViewController.swift
//  QOT
//
//  Created by Sam Wyndham on 01/03/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit

final class ShareViewController: UIViewController, ShareViewControllerInterface {

    @IBOutlet private weak var headerLabel: UILabel!
    @IBOutlet private weak var toBeVisionButton: UIButton!
    @IBOutlet private weak var weeklyChoicesButton: UIButton!
    @IBOutlet private weak var shareButton: UIButton!
    @IBOutlet private weak var partnerImageView: UIImageView!
    @IBOutlet private weak var partnerInitialsLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    var interactor: ShareInteractorInterface?

    init(configure: Configurator<ShareViewController>) {
        super.init(nibName: nil, bundle: nil)
        configure(self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        toBeVisionButton.isSelected = true
        setupCloseButton()
        setupShareButton()
        syncShareButton()
        interactor?.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        syncShareButton()
    }

    func setHeader(_ header: String) {
        headerLabel.text = header
    }

    func setPartnerProfileImage(_ imageURL: URL?, initials: String) {
        partnerImageView.applyHexagonMask()
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

    func setLoading(loading: Bool) {
        toBeVisionButton.isUserInteractionEnabled = !loading
        weeklyChoicesButton.isUserInteractionEnabled = !loading
        shareButton.isHidden = loading
        activityIndicator.isHidden = !loading
    }
}

// MARK: - Private

private extension ShareViewController {

    func setupCloseButton() {
        let closeButton = UIBarButtonItem(withImage: R.image.ic_close())
        closeButton.target = self
        closeButton.action = #selector(didTapClose(_ :))
        navigationItem.rightBarButtonItem = closeButton
    }

    func setupShareButton() {
        shareButton.layer.borderWidth = 1
        shareButton.layer.cornerRadius = 20
    }

    @objc private func didTapClose(_ sender: UIBarButtonItem) {
        interactor?.didTapClose()
    }

    @IBAction private func didTapOption(_ sender: UIButton) {
        guard sender.isSelected == false else { return }
        sender.isSelected = true
        var otherOptions = Set([toBeVisionButton, weeklyChoicesButton])
        otherOptions.remove(sender)
        otherOptions.forEach { $0.isSelected = false }
    }

    @IBAction private func didTapShareButton(_ sender: UIButton) {
        if toBeVisionButton.isSelected == true {
            interactor?.didTapShareToBeVision()
        } else if weeklyChoicesButton.isSelected == true {
            interactor?.didTapShareWeeklyChoices()
        }
    }

    private func syncShareButton() {
        shareButton.setTitleColor(.lightGray, for: .normal)
        shareButton.isEnabled = true
        shareButton.layer.borderColor = UIColor.lightGray.cgColor
    }
}
