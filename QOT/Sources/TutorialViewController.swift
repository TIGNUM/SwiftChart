//
//  TutorialViewController.swift
//  QOT
//
//  Created by Moucheg Mouradian on 24/07/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Anchorage

protocol TutorialViewControllerDelegate: class {
    func didCloseTutorial(completion: @escaping () -> Void)
}

class TutorialViewController: UIViewController {

    // MARK: - Properties

    fileprivate let viewModel: TutorialViewModel
    fileprivate weak var delegate: TutorialViewControllerDelegate?
    // MARK: - Life cycle

    init(viewModel: TutorialViewModel, delegate: TutorialViewControllerDelegate) {
        self.viewModel = viewModel
        self.delegate = delegate

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
        addOverlay()
        addGesture()
    }
}

// MARK: - Private

private extension TutorialViewController {

    func addOverlay() {

        guard let buttonFrame = viewModel.buttonFrame else { return }

        let holeCenterX = buttonFrame.origin.x + buttonFrame.width / 2 + Layout.TabBarView.stackViewHorizontalPaddingBottom
        let holeCenter = CGPoint(x: holeCenterX, y: view.frame.size.height)

        let ovalPath = UIBezierPath(arcCenter: holeCenter, radius: buttonFrame.width / 2, startAngle: Math.radians(180), endAngle: Math.radians(0), clockwise: true)

        let overlayPath = UIBezierPath(rect: view.bounds)
        overlayPath.append(ovalPath)
        overlayPath.usesEvenOddFillRule = true

        let layer = CAShapeLayer()
        layer.path = overlayPath.cgPath
        layer.fillRule = kCAFillRuleEvenOdd

        view.layer.mask = layer
    }

    func addGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissAction))
        view.addGestureRecognizer(tapGesture)
    }

    @objc func dismissAction() {
        UIView.animate(withDuration: 1, animations: { [unowned self] in
            self.view.alpha = 0
        }, completion: { [unowned self] _ in
            self.delegate?.didCloseTutorial(completion: self.viewModel.completion)
        })
    }

    func setupLayout() {
        let titleLabel = UILabel()
        let contentLabel = UILabel()

        let crossImage = UIImageView(image: R.image.crossImage()?.withRenderingMode(.alwaysTemplate))

        view.addSubview(titleLabel)
        view.addSubview(contentLabel)
        view.addSubview(crossImage)

        view.backgroundColor = UIColor.black70
        view.alpha = 0

        crossImage.tintColor = .white

        titleLabel.backgroundColor = .clear
        titleLabel.numberOfLines = 1
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.textColor = .white
        titleLabel.prepareAndSetTextAttributes(text: viewModel.title, font: Font.H4Headline, alignment: .left, lineSpacing: 7, characterSpacing: -0.8)

        contentLabel.backgroundColor = .clear
        contentLabel.text = viewModel.content
        contentLabel.textAlignment = .left
        contentLabel.numberOfLines = 0
        contentLabel.lineBreakMode = .byWordWrapping
        contentLabel.font = Font.DPText
        contentLabel.text = viewModel.content
        contentLabel.attributedText = Style.article(viewModel.content, .white).attributedString(lineHeight: 1.7)

        crossImage.topAnchor == view.topAnchor + 30
        crossImage.rightAnchor == view.rightAnchor - 20
        crossImage.widthAnchor == 17
        crossImage.heightAnchor == 17

        titleLabel.bottomAnchor == contentLabel.topAnchor
        titleLabel.leftAnchor == view.leftAnchor + 27
        titleLabel.rightAnchor == view.rightAnchor - 86
        titleLabel.heightAnchor == 26

        contentLabel.bottomAnchor == view.bottomAnchor - 94
        contentLabel.leftAnchor == view.leftAnchor + 27
        contentLabel.rightAnchor == view.rightAnchor - 86
        contentLabel.heightAnchor <= view.heightAnchor - 120

        view.layoutIfNeeded()

        UIView.animate(withDuration: 1) { [unowned self] in
            self.view.alpha = 1
        }
    }
}
