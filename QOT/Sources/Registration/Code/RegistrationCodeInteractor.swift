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
    private let delegate: RegistrationDelegate
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

    var description: NSAttributedString {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 5
        let description = NSMutableAttributedString(string: worker.description,
                                                    attributes: [.paragraphStyle: style])
        let email = NSAttributedString(string: worker.email,
                                       attributes: [.font: UIFont.sfProtextSemibold(ofSize: 16)])
        description.append(email)
        return description
    }

    var disclaimer: NSAttributedString {
        let plainDisclaimer = NSAttributedString(string: worker.disclaimer, attributes: defaultAttributes)
        let disclaimer = NSMutableAttributedString(attributedString: plainDisclaimer)
        // Terms
        let terms = worker.disclaimerTermsPlaceholder
        if let range = disclaimer.string.range(of: terms) {
            disclaimer.addAttributes(linkAttributes(for: URLActions.termsOfUse.link()),
                                     range: NSRange(range, in: disclaimer.string))
        }
        // Privacy
        let privacy = worker.disclaimerPrivacyPlaceholder
        if let range = disclaimer.string.range(of: privacy) {
            disclaimer.addAttributes(linkAttributes(for: URLActions.privacyPolicy.link()),
                                     range: NSRange(range, in: disclaimer.string))
        }
        return disclaimer
    }

    var codeInfo: NSAttributedString {
        let plainCodeInfo = NSAttributedString(string: worker.codeInfo + "\n", attributes: defaultAttributes)
        let codeInfo = NSMutableAttributedString(attributedString: plainCodeInfo)
        // Change email
        let changeEmail = NSAttributedString(string: worker.changeEmail,
                                             attributes: linkAttributes(for: URLActions.changeEmail.link()))
        codeInfo.append(changeEmail)
        codeInfo.append(NSAttributedString(string: " - ", attributes: defaultAttributes))
        // Send again
        let sendAgain = NSAttributedString(string: worker.sendAgain,
                                          attributes: linkAttributes(for: URLActions.resendCode.link()))
        codeInfo.append(sendAgain)
        codeInfo.append(NSAttributedString(string: " - ", attributes: defaultAttributes))
        // Help
        let help = NSAttributedString(string: worker.help,
                                      attributes: linkAttributes(for: URLActions.getHelp.link()))
        codeInfo.append(help)

        return codeInfo
    }
}

// MARK: - RegistrationCodeInteractorInterface

extension RegistrationCodeInteractor: RegistrationCodeInteractorInterface {

    func viewDidLoad() {
        presenter.setup()
    }

    func didTapBack() {
        delegate.didTapBack()
    }

    func handleURLAction(url: URL) {
        guard url.scheme == URLActions.urlProtocol, let host = url.host, let action = URLActions(rawValue: host) else {
            return
        }
        switch action {
        case .changeEmail:
            delegate.didTapBack()
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
        worker.validate(code: code, for: worker.email) { [weak self] (result, error) in
            self?.presenter.presentActivity(state: nil)
            if case .codeValid = result.code {
                self?.delegate.didVerifyCode(code)
                return
            } else if case .codeInvalid = result.code {
                self?.errorMessage = self?.worker.codeError
            } else {
                self?.errorMessage = self?.worker.resendCodeError
                if let error = error {
                    qot_dal.log("Error when checking registration code: \(error)", level: .debug)
                }
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
                qot_dal.log("Error when resending code: \(error)", level: .debug)
                self?.hasCodeError = true
                self?.errorMessage = self?.worker.resendCodeError
                self?.presenter.present()
                self?.presenter.presentActivity(state: nil)
            }
            self?.presenter.presentActivity(state: .success)
        }
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
