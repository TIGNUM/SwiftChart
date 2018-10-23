//
//  AbstractFormViewController.swift
//  QOT
//
//  Created by karmic on 15.06.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit

class AbstractFormViewController: UIViewController {

    // MARK: - Properties

    @IBOutlet private weak var textInputTopConstraint: NSLayoutConstraint?
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet internal weak var bottomButton: UIButton!
    @IBOutlet internal weak var titleContentView: UIView!
    private let keyboardListener = KeyboardListener()
    private var defaultTextInputTopConstant = CGFloat(0)

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        if UIDevice.isPad {
            defaultTextInputTopConstant = 0
            textInputTopConstraint?.constant = 0
        } else {
            defaultTextInputTopConstant = textInputTopConstraint?.constant ?? 0
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        keyboardListener.startObserving()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        keyboardListener.stopObserving()
    }
}

extension AbstractFormViewController {

    @objc func formView() -> FormView? {
        return R.nib.formView.instantiate(withOwner: nil).first as? FormView
    }

    @objc func setupView(title: String, subtitle: String, bottomButtonTitle: String) {
        view.backgroundColor = .navy
        addGestureRecognizer()
        setupLabels(title: title, subtitle: subtitle)
        setupBottomButton(buttonTitle: bottomButtonTitle)
        keyboardListener.onStateChange { [weak self] _ in
            self?.updateTextInputConstraints()
        }
    }

    @objc func endEditing() {
        UIView.animate(withDuration: 0.75, delay: 0, options: .curveEaseOut, animations: {
            self.view.endEditing(true)
        })
    }

    @objc func updateBottomButton(_ active: Bool) {
        bottomButton.backgroundColor = active == false ? .clear : .azure
        bottomButton.layer.borderColor = active == false ? UIColor.white36.cgColor : UIColor.azure.cgColor
    }
}

// MARK: - Private

private extension AbstractFormViewController {

    func addGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    func updateTextInputConstraints() {
        textInputTopConstraint?.constant = max(-40, defaultTextInputTopConstant - keyboardListener.state.height)
        UIView.animate(withDuration: 1) { [weak self] in
            self?.view.layoutIfNeeded()
            self?.view.updateConstraints()
        }
    }

    @objc func setupLabels(title: String, subtitle: String) {
        titleLabel.attributedText = NSMutableAttributedString(string: title,
                                                              letterSpacing: 1.5,
                                                              font: .H3Subtitle,
                                                              lineSpacing: 2,
                                                              textColor: .white,
                                                              alignment: .left)
        subtitleLabel.attributedText = NSMutableAttributedString(string: subtitle,
                                                                 letterSpacing: 0.8,
                                                                 font: .DPText,
                                                                 lineSpacing: 8,
                                                                 textColor: .white90,
                                                                 alignment: .left)
    }

    func setupBottomButton(buttonTitle: String) {
        let attributedTitle = NSMutableAttributedString(string: buttonTitle,
                                                        letterSpacing: 0.8,
                                                        font: .DPText,
                                                        textColor: .white90,
                                                        alignment: .center)
        bottomButton.setAttributedTitle(attributedTitle, for: .selected)
        bottomButton.setAttributedTitle(attributedTitle, for: .normal)
        bottomButton.backgroundColor = .clear
        bottomButton.layer.borderWidth = 1
        bottomButton.layer.borderColor = UIColor.white36.cgColor
        bottomButton.corner(radius: Layout.CornerRadius.eight.rawValue)
    }
}
