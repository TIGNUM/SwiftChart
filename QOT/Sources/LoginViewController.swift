//
//  LoginViewController.swift
//  QOT
//
//  Created by Aamir Suhial Mir on 7/5/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Anchorage

protocol LoginViewControllerDelegate: class {

    func didTapLogin(withEmail email: String, password: String, viewController: UIViewController, completion: @escaping (Error?) -> Void)

    func didTapResetPassword(viewController: UIViewController)
}

final class LoginViewController: UITableViewController {

    // MARK: - Properties

    fileprivate weak var delegate: LoginViewControllerDelegate?

    // MARK: - Initialisation

    init(delegate: LoginViewControllerDelegate?) {
        self.delegate = delegate
        
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        registerCell()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.backgroundView = UIImageView(image: R.image.loginBackground())
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: -20, right: 0)        
        hideKeyboardWhenTappedAround()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        startObservingKeyboard()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        stopObservingKeyboard()
    }
}

extension LoginViewController {

    @objc override func keyboardWillAppear(notification: NSNotification) {
        guard let cell = tableView.visibleCells[0] as? LoginViewCell else { return }

        cell.keyboardWillAppear()
    }

    @objc override func keyboardWillDisappear(notification: NSNotification) {
        let contentInsets = UIEdgeInsets(top: 20, left: 0, bottom: -20, right: 0)
        tableView.contentInset = contentInsets
        tableView.scrollIndicatorInsets = contentInsets
    }
}

// MARK: - LoginViewCellDelegate

extension LoginViewController: LoginViewCellDelegate {
    func keyboardAppeared(viewHeight: CGFloat) {

        let bottom: CGFloat = viewHeight - tableView.frame.height

        let contentInsets = UIEdgeInsets(top: 20, left: 0, bottom: bottom, right: 0)
        tableView.contentInset = contentInsets
        tableView.scrollIndicatorInsets = contentInsets
    }

    func didTapLogin(withEmail email: String, password: String, completion: @escaping (Error?) -> Void) {
        delegate?.didTapLogin(withEmail: email, password: password, viewController: self, completion: completion)
    }
}

extension LoginViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: LoginViewCell = tableView.dequeueCell(for: indexPath)
        cell.configure(delegate: self.delegate, cellDelegate: self, parentViewController: self)

        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height
    }
}

// MARK: - Private

private extension LoginViewController {

    func registerCell() {
        tableView.registerDequeueable(LoginViewCell.self)
    }

    func setupLayout() {
        tableView.horizontalAnchors == horizontalAnchors
        tableView.verticalAnchors == verticalAnchors
        
        view.layoutIfNeeded()
    }
}
