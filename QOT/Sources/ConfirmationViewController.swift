//
//  ConfirmationViewController.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 09.05.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

protocol ConfirmationViewControllerDelegate: class {
    func didTapLeave()
    func didTapStay()
}

final class ConfirmationViewController: UIViewController {

    // MARK: - Properties
    weak var delegate: ConfirmationViewControllerDelegate?
    var interactor: ConfirmationInteractorInterface?
    private var confirmation: Confirmation?
    @IBOutlet private weak var infoAlertView: InfoAlertView!

    // MARK: - Init
    init(configure: Configurator<ConfirmationViewController>) {
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

// MARK: - Actions
private extension ConfirmationViewController {
    @objc func didTapRight() {
        interactor?.didTapLeave()
    }

    @objc func didTapLeft() {
        interactor?.didTapDismiss()
    }
}

// MARK: - ConfirmationViewControllerInterface
extension ConfirmationViewController: ConfirmationViewControllerInterface {
    func setupView() {
        infoAlertView?.bottomInset = BottomNavigationContainer.height
        infoAlertView?.setBackgroundColor(.clear)
    }

    func load(_ confirmationModel: Confirmation) {
        self.confirmation = confirmationModel
        infoAlertView.set(icon: R.image.warning(), title: confirmation?.title, text: confirmation?.description)
    }
}

extension ConfirmationViewController {
    override func bottomNavigationLeftBarItems() -> [UIBarButtonItem]? {
        return nil
    }

    override func bottomNavigationRightBarItems() -> [UIBarButtonItem]? {
        let titleCancel = confirmation?.buttonTitleDismiss ?? R.string.localized.buttonTitleCancel()
        let titleContinue = confirmation?.buttonTitleConfirm ?? R.string.localized.profileConfirmationDoneButton()
        let cancelButtonItem = roundedBarButtonItem(title: titleCancel,
                                                    buttonWidth: .Cancel,
                                                    action: #selector(didTapLeft),
                                                    backgroundColor: .clear,
                                                    borderColor: .accent40)
        let continueButtonItem = roundedBarButtonItem(title: titleContinue,
                                                      buttonWidth: .Continue,
                                                      action: #selector(didTapRight),
                                                      backgroundColor: .clear,
                                                      borderColor: .accent40)
        return [continueButtonItem, cancelButtonItem]
    }
}
