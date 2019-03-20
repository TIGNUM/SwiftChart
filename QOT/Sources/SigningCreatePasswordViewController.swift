//
//  SigningCreatePasswordViewController.swift
//  QOT
//
//  Created by karmic on 07.06.18.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import UIKit

final class SigningCreatePasswordViewController: AbstractFormViewController {

    // MARK: - Properties

    @IBOutlet private weak var successOverlay: UIView!
    @IBOutlet private weak var successOverlayLabel: UILabel!
    @IBOutlet private weak var centerContentView: UIView!
    @IBOutlet private weak var passwordInfoContentView: UIView!
    @IBOutlet private weak var passwordInfoCharacterLabel: UILabel!
    @IBOutlet private weak var passwordInfoUppercaseLabel: UILabel!
    @IBOutlet private weak var passwordInfoSpecialCharacterLabel: UILabel!
	@IBOutlet private weak var topConstraint: NSLayoutConstraint!
	var interactor: SigningCreatePasswordInteractorInterface?
    @IBOutlet private weak var centerContentViewTopConstraint: NSLayoutConstraint!

    private lazy var formView: FormView? = {
        let form = R.nib.formView().instantiate(withOwner: nil, options: nil).first as? FormView
        form?.delegate = self
        return form
    }()

    // MARK: - Init

    init(configure: Configurator<SigningCreatePasswordViewController>) {
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

private extension SigningCreatePasswordViewController {

    func handleOverlayView() {
        Timer.scheduledTimer(withTimeInterval: 2.5, repeats: false) { [weak self] (_) in
            UIView.animate(withDuration: 0.8) { [weak self] in
                self?.hideSubviews(isHidden: false)
                self?.successOverlay.isHidden = true
            }
        }
    }

    func hideSubviews(isHidden: Bool) {
        bottomButton.isHidden = isHidden
        titleContentView.isHidden = isHidden
        centerContentView.isHidden = isHidden
    }

    func setupPasswordInfoLabels() {
        passwordInfoCharacterLabel.attributedText = attributedString(R.string.localized.signingPasswordHintCharacter())
        passwordInfoUppercaseLabel.attributedText = attributedString(R.string.localized.signingPasswordHintUppercase())
        passwordInfoSpecialCharacterLabel.attributedText = attributedString(R.string.localized.signingPasswordHintSpecial())
    }

    func attributedString(_ string: String) -> NSMutableAttributedString {
        return NSMutableAttributedString(string: string,
                                         letterSpacing: 0.6,
                                         font: .apercuLight(ofSize: 11),
                                         textColor: .white60,
                                         alignment: .left)
    }

    func setupFormView() {
        guard let formView = formView else { return }
        centerContentView.addSubview(formView)
        formView.configure(formType: .password(""))
        if UIDevice.isPad {
            centerContentViewTopConstraint.constant = Layout.padding_1
        }
        let model = UIDevice.current.deviceName
        if model.contains("iPhone 5") || model.contains("iPhone 4") || model.contains("iPhone 3") {
             centerContentViewTopConstraint.constant = Layout.padding_32
        }
		if #available(iOS 11.0, *) {
		} else {
			topConstraint.constant = Layout.statusBarHeight
		}
    }
}

// MARK: - Actions

private extension SigningCreatePasswordViewController {

    @IBAction func didTapButton() {
        interactor?.didTapNext()
    }
}

// MARK: - SigningCreatePasswordViewControllerInterface

extension SigningCreatePasswordViewController: SigningCreatePasswordViewControllerInterface {

    override func endEditing() {
        formView?.resetPlaceholderLabelIfNeeded()
        super.endEditing()
    }

    func hideErrorMessage() {
        formView?.hideError()
        passwordInfoContentView.isHidden = true
    }

    func activateButton(_ active: Bool) {
        updateBottomButton(active)
    }

    func reload(errorMessage: String?, buttonActive: Bool) {
        if let message = errorMessage {
            formView?.showError(message: message)
            passwordInfoContentView.isHidden = false
        }
        updateBottomButton(buttonActive)
    }

    func setup() {
        hideSubviews(isHidden: true)
        passwordInfoContentView.isHidden = true
        setupView(title: R.string.localized.signingPasswordTitle(),
                  subtitle: R.string.localized.signingPasswordSubtitle(),
                  bottomButtonTitle: R.string.localized.signingPasswordBottomButtonTitle())
        setupFormView()
        setupPasswordInfoLabels()
        handleOverlayView()
    }
}

// MARK: - FormViewDelegate

extension SigningCreatePasswordViewController: FormViewDelegate {

    func didBeginEditingTextField(formType: FormView.FormType?) {}

    func didTapReturn(formType: FormView.FormType?) {
        formView?.activateTextField(false)
        interactor?.didTapNext()
    }

    func didEndEditingTextField(formType: FormView.FormType?) {
        interactor?.updateWorkerValue(for: formType)
    }

    func didUpdateTextfield(formType: FormView.FormType?) {
        interactor?.updateWorkerValue(for: formType)
    }
}
