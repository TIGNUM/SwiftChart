//
//  TutorialViewController.swift
//  QOT
//
//  Created by Moucheg Mouradian on 24/07/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Anchorage

class TutorialViewController: UIViewController {

    // MARK: - Properties

    fileprivate let viewModel: TutorialViewModel
    fileprivate let buttonFrame: CGRect
    fileprivate var completion: (() -> Void)?
    fileprivate var crossImageView: UIImageView!
    fileprivate var titleLabel: UILabel!
    fileprivate var contentLabel: UILabel!
    
    // MARK: - Life cycle

    init(viewModel: TutorialViewModel, buttonFrame: CGRect, completion: (() -> Void)?) {
        self.viewModel = viewModel
        self.buttonFrame = buttonFrame
        self.completion = completion

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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.crossImageView.alpha = 1.0
            self.titleLabel.alpha = 1.0
            self.contentLabel.alpha = 1.0
        }, completion: nil)
    }
}

// MARK: - Private

private extension TutorialViewController {

    func addOverlay() {
        let centerX = buttonFrame.midX + Layout.TabBarView.stackViewHorizontalPaddingBottom
        let holeCenter = CGPoint(x: centerX, y: view.frame.size.height)
        let overlayPath = UIBezierPath(rect: view.bounds)
        overlayPath.append(UIBezierPath(arcCenter: holeCenter, radius: buttonFrame.width * 0.75, startAngle: Math.radians(180), endAngle: Math.radians(0), clockwise: true))
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
        UIView.animate(withDuration: 1, animations: {
            self.view.alpha = 0
        }, completion: { _ in
            self.completion?()
        })
    }

    func setupLayout() {
        titleLabel = UILabel()
        contentLabel = UILabel()
        crossImageView = UIImageView(image: R.image.crossImage()?.withRenderingMode(.alwaysTemplate))

        view.addSubview(titleLabel)
        view.addSubview(contentLabel)
        view.addSubview(crossImageView)

        view.backgroundColor = UIColor.black70
        
        crossImageView.alpha = 0.0
        crossImageView.tintColor = .white
        
        titleLabel.alpha = 0.0
        titleLabel.backgroundColor = .clear
        titleLabel.numberOfLines = 1
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.textColor = .white
        titleLabel.setAttrText(text: viewModel.title, font: Font.H4Headline, alignment: .left, lineSpacing: 7, characterSpacing: -0.8)

        contentLabel.alpha = 0.0
        contentLabel.backgroundColor = .clear
        contentLabel.text = viewModel.content
        contentLabel.textAlignment = .left
        contentLabel.numberOfLines = 0
        contentLabel.lineBreakMode = .byWordWrapping
        contentLabel.font = Font.DPText
        contentLabel.text = viewModel.content
        contentLabel.attributedText = Style.article(viewModel.content, .white).attributedString(lineHeight: 1.7)

        crossImageView.topAnchor == view.topAnchor + 30
        crossImageView.rightAnchor == view.rightAnchor - 20
        crossImageView.widthAnchor == 17
        crossImageView.heightAnchor == 17

        titleLabel.bottomAnchor == contentLabel.topAnchor
        titleLabel.leftAnchor == view.leftAnchor + 27
        titleLabel.rightAnchor == view.rightAnchor - 86
        titleLabel.heightAnchor == 26

        contentLabel.bottomAnchor == view.bottomAnchor - 94
        contentLabel.leftAnchor == view.leftAnchor + 27
        contentLabel.rightAnchor == view.rightAnchor - 86
        contentLabel.heightAnchor <= view.heightAnchor - 120

        view.layoutIfNeeded()
    }
}
