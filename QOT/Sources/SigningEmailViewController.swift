//
//  SigningEmailViewController.swift
//  QOT
//
//  Created by karmic on 29.05.18.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import UIKit

final class SigningEmailViewController: AbstractFormViewController {

    // MARK: - Properties

    @IBOutlet private weak var topContentView: UIView!
    @IBOutlet private weak var centerContentView: UIView!
    private lazy var emailFormView: FormView? = formView()
    var interactor: SigningEmailInteractorInterface?

    // MARK: - Init

    init(configure: Configurator<SigningEmailViewController>) {
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

private extension SigningEmailViewController {

    func setupFormView() {
        guard let formView = emailFormView else { return }
        formView.delegate = self
        centerContentView.addSubview(formView)
        formView.configure(formType: .email(""))
    }
}

// MARK: - SigningEmailViewControllerInterface

extension SigningEmailViewController: SigningEmailViewControllerInterface {

    override func endEditing() {
        emailFormView?.resetPlaceholderLabelIfNeeded()
        super.endEditing()
    }

    func hideErrorMessage() {
        emailFormView?.hideError()
    }

    func activateButton(_ active: Bool) {
        updateBottomButton(active)
    }

    func reload(errorMessage: String?, buttonActive: Bool) {
        if let message = errorMessage {
            emailFormView?.showError(message: message)
        }
        updateBottomButton(buttonActive)
    }

    func setup() {
        setupView(title: R.string.localized.signingEmailCheckTitle(),
                  subtitle: R.string.localized.signingEmailCheckSubtitle(),
                  bottomButtonTitle: R.string.localized.signingEmailCheckBottomButtonTitle())
        setupFormView()
    }
}

// MARK: - Action

private extension SigningEmailViewController {

    @IBAction func didTapButton() {
        interactor?.didTapNext()
    }
}

// MARK: - FormViewDelegate

extension SigningEmailViewController: FormViewDelegate {

    func didBeginEditingTextField(formType: FormView.FormType?) {}

    func didTapReturn(formType: FormView.FormType?) {
        emailFormView?.activateTextField(false)
        interactor?.didTapNext()
    }

    func didEndEditingTextField(formType: FormView.FormType?) {
        interactor?.updateWorkerValue(for: formType)
    }

    func didUpdateTextfield(formType: FormView.FormType?) {
        interactor?.updateWorkerValue(for: formType)
    }
}
