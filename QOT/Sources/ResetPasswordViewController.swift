//
//  ResetPasswordViewController.swift
//  QOT
//
//  Created by Moucheg Mouradian on 10/07/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Anchorage

protocol ResetPasswordViewControllerDelegate: class {
    func didTapResetPassword(withUsername username: String, completion: @escaping (NetworkError?) -> Void)
    func didTapBack(viewController: UIViewController)
    func checkIfEmailAvailable(email: String, completion: @escaping (Bool) -> Void)
}

class ResetPasswordViewController: UITableViewController {

    // MARK: - Properties

    fileprivate weak var delegate: ResetPasswordViewControllerDelegate?

    // MARK: - Initialisation

    init(delegate: ResetPasswordViewControllerDelegate?) {
        self.delegate = delegate
        
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        registerCell()
        hideKeyboardWhenTappedAround()
        startObservingKeyboard()

        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: -20, right: 0)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.backgroundView = UIImageView(image: R.image.loginBackground())
        tableView.separatorStyle = .none
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        stopObservingKeyboard()
    }
}

extension ResetPasswordViewController {

    @objc override func keyboardWillAppear(notification: NSNotification) {
        guard let cell = tableView.visibleCells[0] as? ResetPasswordViewCell else { return }
        cell.keyboardWillAppear()
    }

    @objc override func keyboardWillDisappear(notification: NSNotification) {
        let contentInsets = UIEdgeInsets(top: 20, left: 0, bottom: -20, right: 0)
        tableView.contentInset = contentInsets
        tableView.scrollIndicatorInsets = contentInsets
    }
}

// MARK: - ResetPasswordViewCellDelegate

extension ResetPasswordViewController: ResetPasswordViewCellDelegate {
    func keyboardAppeared(viewHeight: CGFloat) {

        let bottom: CGFloat = viewHeight - tableView.frame.height

        let contentInsets = UIEdgeInsets(top: 20, left: 0, bottom: bottom, right: 0)
        tableView.contentInset = contentInsets
        tableView.scrollIndicatorInsets = contentInsets
    }

    func didTapResetPassword(withUserName username: String, successCompletion: @escaping () -> Void) {
        delegate?.didTapResetPassword(withUsername: username) { [weak self] error in
            guard let failure = error else {

                successCompletion()

                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: { [weak self] in
                    guard let strongSelf = self else { return }
                    strongSelf.delegate?.didTapBack(viewController: strongSelf)
                    return
                })

                return
            }

            switch failure.type {
            case .noNetworkConnection:
                self?.showAlert(type: .noNetworkConnection)
            default:
                self?.showAlert(type: .unknow)
            }
        }
    }
}

extension ResetPasswordViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell: ResetPasswordViewCell = tableView.dequeueCell(for: indexPath)
        cell.configure(delegate: self.delegate, cellDelegate: self, parentViewController: self)
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height
    }
}

extension ResetPasswordViewController {

    func registerCell() {
        tableView.registerDequeueable(ResetPasswordViewCell.self)
    }

    func setupLayout() {
        tableView.horizontalAnchors == horizontalAnchors
        tableView.verticalAnchors == verticalAnchors
        
        view.layoutIfNeeded()
    }
}
