//
//  MyToBeVisionView.swift
//  QOTWidget
//
//  Created by Javier Sanz Rozalen on 05/07/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit
import Kingfisher

protocol MyToBeVisionViewDelegate: class {
    func didTapCreateToBeVision(in view: UIView)
    func didTapSignIn(in view: UIView)
}

final class MyToBeVisionView: UIView {

    // MARK: - Properties

    @IBOutlet private weak var noNetworkLabel: UILabel!
    @IBOutlet private weak var toBeVisionContainer: UIView!
    @IBOutlet private weak var toBeVisionImageView: UIImageView!
    @IBOutlet private weak var signinContainer: UIView!
    @IBOutlet private weak var toBeVisionHeadline: UILabel!
    @IBOutlet private weak var toBeVisionText: UILabel!
    @IBOutlet private weak var createToBeVisionButton: UIButton!
    @IBOutlet private weak var openQotButton: UIButton!
    weak var delegate: MyToBeVisionViewDelegate?

    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layout()
    }

    // MARK: - Actions

    func configure(toBeVision: WidgetModel.ToBeVision, isNetworkAvailable: Bool, isSignedIn: Bool) {
        noNetworkLabel.isHidden = isNetworkAvailable == true
        signinContainer.isHidden = isSignedIn == true
        toBeVisionContainer?.isHidden = isSignedIn == false || isNetworkAvailable == false
        if let headline = toBeVision.headline {
            toBeVisionHeadline.text = headline.capitalized
        }
        if let text = toBeVision.text {
            toBeVisionText.text = text
			createToBeVisionButton.isHidden = true
        }
        if let imageURL = toBeVision.imageURL {
            toBeVisionImageView.kf.setImage(with: imageURL)
            return
        }
        toBeVisionImageView.image = UIImage(named: "Universe mytobevision")
    }

    @IBAction func didTapCreateToBeVision(_ sender: UIButton) {
        delegate?.didTapCreateToBeVision(in: self)
    }

    @IBAction func didTapOpenQot(_ sender: UIButton) {
        delegate?.didTapSignIn(in: self)
    }
}

// MARK: - Private

extension MyToBeVisionView {

    func setupView() {
        noNetworkLabel.adjustsFontSizeToFitWidth = true
        toBeVisionImageView.layer.masksToBounds = true
		toBeVisionText.textColor = .gray
    }

    func layout() {
        openQotButton.layer.cornerRadius = 6
        createToBeVisionButton.layer.cornerRadius = 6
        toBeVisionImageView.layer.cornerRadius = toBeVisionImageView.frame.height / 2
    }
}
