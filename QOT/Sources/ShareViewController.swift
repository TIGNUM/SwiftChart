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

        let closeButton = UIBarButtonItem(withImage: R.image.ic_close())
        closeButton.target = self
        closeButton.action = #selector(didTapClose(_ :))
        navigationItem.rightBarButtonItem = closeButton

        shareButton.layer.borderWidth = 1
        shareButton.layer.cornerRadius = 20
        syncShareButton()
        interactor?.viewDidLoad()
    }

    func setHeader(_ header: String) {
        headerLabel.text = header
    }

    func setLoading(loading: Bool) {
        toBeVisionButton.isEnabled = !loading
        weeklyChoicesButton.isEnabled = !loading
        shareButton.isHidden = loading
        activityIndicator.isHidden = !loading
    }
}

private extension ShareViewController {

    @objc private func didTapClose(_ sender: UIBarButtonItem) {
        interactor?.didTapClose()
    }

    @IBAction private func didTapOption(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected

        if sender.isSelected {
            var otherOptions = Set([toBeVisionButton, weeklyChoicesButton])
            otherOptions.remove(sender)
            otherOptions.forEach { $0.isSelected = false }
        }
        syncShareButton()
    }

    @IBAction private func didTapShareButton(_ sender: UIButton) {
        if toBeVisionButton.isSelected {
            interactor?.didTapShareToBeVision()
        } else if weeklyChoicesButton.isSelected {
            interactor?.didTapShareWeeklyChoices()
        }
    }

    private func syncShareButton() {
        let enabled = toBeVisionButton.isSelected || weeklyChoicesButton.isSelected
        let color: UIColor = enabled ? .lightGray : UIColor(white: 0.66, alpha: 0.2)
        shareButton.setTitleColor(color, for: .normal)
        shareButton.isEnabled = enabled
        shareButton.layer.borderColor = color.cgColor
    }
}
