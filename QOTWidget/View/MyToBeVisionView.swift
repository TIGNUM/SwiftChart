//
//  MyToBeVisionView.swift
//  QOTWidget
//
//  Created by Javier Sanz Rozalen on 05/07/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit

protocol MyToBeVisionViewDelegate: class {
    func didTapCreateToBeVision()
    func didTapShowToBeVision()
    func didTapSignIn()
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
            addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showToBeVision)))
        }
        if let imageURL = toBeVision.imageURL, let data = try? Data(contentsOf: imageURL) {
            toBeVisionImageView.image = UIImage(data: data)
            return
        }
        toBeVisionImageView.image = UIImage(named: "tbv_placeholder")
        toBeVisionImageView.backgroundColor = UIColor(red: 2/255, green: 18/255, blue: 33/255, alpha: 1)
    }

    @IBAction func didTapCreateToBeVision(_ sender: UIButton) {
        delegate?.didTapCreateToBeVision()
    }

    @IBAction func didTapOpenQot(_ sender: UIButton) {
        delegate?.didTapSignIn()
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
    
    @objc func showToBeVision() {
        delegate?.didTapShowToBeVision()
    }
}
