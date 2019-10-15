//
//  RegistrationCodeInteractor.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 10/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

private enum URLActions: String {
    static let urlProtocol = "qotApp"
    case termsOfUse
    case privacyPolicy
    case changeEmail
    case resendCode
    case getHelp

    func link() -> String {
        return URLActions.urlProtocol + "://" + self.rawValue
    }
}

final class RegistrationCodeInteractor {

    // MARK: - Properties

    private let worker: RegistrationCodeWorker
    private let presenter: RegistrationCodePresenterInterface
    private let router: RegistrationCodeRouterInterface
    private weak var delegate: RegistrationDelegate?
    private var termsAccepted: Bool = false

    private lazy var defaultAttributes: [NSAttributedStringKey: Any] = {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 5
        return [.font: UIFont.sfProtextRegular(ofSize: 14), .foregroundColor: UIColor.sand70, .paragraphStyle: style]
    }()

    private lazy var linkAttributes: [NSAttributedStringKey: Any] = {
        return [.font: UIFont.sfProtextSemibold(ofSize: 14), .foregroundColor: UIColor.accent]
    }()

    var hasCodeError: Bool = false
    var hasDisclaimerError: Bool = false
    var errorMessage: String? = nil

    // MARK: - Init

    init(worker: RegistrationCodeWorker,
        presenter: RegistrationCodePresenterInterface,
        router: RegistrationCodeRouterInterface,
        delegate: RegistrationDelegate) {
        self.worker = worker
        self.presenter = presenter
        self.router = router
        self.delegate = delegate
    }

    // MARK: - Texts

    var title: String {
        return worker.title
    }

    var description: String {
        return worker.description
    }

    var descriptionEmail: String {
        return worker.email
    }

    var preCode: String {
        return worker.preCode
    }

    var disclaimerError: String {
        return worker.disclaimerError
    }

    var disclaimer: NSAttributedString {
        let disclaimer = NSMutableAttributedString(attributedString:
            ThemeText.registrationCodeTermsAndPrivacy.attributedString(worker.disclaimer))
        // Terms
        let terms = worker.disclaimerTermsPlaceholder
        if let range = disclaimer.string.range(of: terms) {
            let termsOfUse = ThemeText.registrationCodeLink(URLActions.termsOfUse.link()).attributedString(terms)
            disclaimer.replaceCharacters(in: NSRange(range, in: disclaimer.string), with: termsOfUse)
        }
        // Privacy
        let privacy = worker.disclaimerPrivacyPlaceholder
        if let range = disclaimer.string.range(of: privacy) {
            let privacyPolicy = ThemeText.registrationCodeLink(URLActions.privacyPolicy.link()).attributedString(privacy)
            disclaimer.replaceCharacters(in: NSRange(range, in: disclaimer.string), with: privacyPolicy)
        }
        return disclaimer
    }

    var codeInfo: NSAttributedString {
        let codeInfo = NSMutableAttributedString(attributedString:
            ThemeText.registrationCodeInfoActions.attributedString(worker.codeInfo + "\n"))
        let dash = ThemeText.registrationCodeInfoActions.attributedString(" - ")
        // Change email
        codeInfo.append(ThemeText.registrationCodeLink(URLActions.changeEmail.link()).attributedString(worker.changeEmail))
        codeInfo.append(dash)
        // Send again
        codeInfo.append(ThemeText.registrationCodeLink(URLActions.resendCode.link()).attributedString(worker.sendAgain))
        codeInfo.append(dash)
        // Help
        codeInfo.append(ThemeText.registrationCodeLink(URLActions.getHelp.link()).attributedString(worker.help))

        return codeInfo
    }
}

// MARK: - RegistrationCodeInteractorInterface

extension RegistrationCodeInteractor: RegistrationCodeInteractorInterface {

    func viewDidLoad() {
        presenter.setup()
    }

    func didTapBack() {
        delegate?.didTapBack()
    }

    func handleURLAction(url: URL) {
        guard url.scheme == URLActions.urlProtocol, let host = url.host, let action = URLActions(rawValue: host) else {
            return
        }
        switch action {
        case .changeEmail:
            delegate?.didTapBack()
        case .resendCode:
            resendCode()
        case .privacyPolicy:
            router.showPrivacyPolicy()
        case .termsOfUse:
            router.showTermsOfUse()
        case .getHelp:
            presenter.presentGetHelp()
        }
    }

    func toggleTermsOfUse(accepted: Bool) {
        termsAccepted = accepted
        hasDisclaimerError = !accepted
        presenter.present()
    }

    func validateLoginCode(_ code: String) {
        guard termsAccepted else {
            hasDisclaimerError = true
            presenter.present()
            return
        }
        presenter.presentActivity(state: .inProgress)
        worker.validate(code: code, for: worker.email, forLogin: false) { [weak self] (result, error) in
            self?.presenter.presentActivity(state: nil)
            if case .codeValid = result.code {
                self?.delegate?.didVerifyCode(code)
                return
            } else if case .codeInvalid = result.code {
                self?.errorMessage = self?.worker.codeError
            } else {
                self?.errorMessage = result.message ?? self?.worker.resendCodeError
                if let error = error { log("Error checking registration code: \(error)", level: .error) }
            }
            // Unsuccessful code check
            self?.hasCodeError = true
            self?.presenter.present()
        }
    }

    func resetErrors() {
        hasDisclaimerError = false
        hasCodeError = false
        errorMessage = nil
    }

    func resendCode() {
        presenter.presentActivity(state: .inProgress)
        worker.requestCode(for: worker.email) { [weak self] (result, error) in
            if let error = error {
                log("Error when resending code: \(error)", level: .debug)
                self?.hasCodeError = true
                self?.errorMessage = result.message ?? self?.worker.resendCodeError
                self?.presenter.present()
                self?.presenter.presentActivity(state: nil)
            }
            self?.presenter.presentActivity(state: .success)
        }
    }

    func showFAQScreen() {
        router.showFAQScreen()
    }
}

// Private methods

private extension RegistrationCodeInteractor {
    func linkAttributes(for link: String) -> [NSAttributedString.Key: Any] {
        var attributes = linkAttributes
        attributes[.link] = link
        return attributes
    }
}
