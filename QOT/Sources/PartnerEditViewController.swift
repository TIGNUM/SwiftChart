//
//  PartnerEditViewController.swift
//  QOT
//
//  Created by karmic on 12.05.18.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import UIKit

final class PartnerEditViewController: UITableViewController {

    // MARK: - Properties

    private var partner: Partners.Partner?
    private var tempImage: UIImage?
    var interactor: PartnerEditInteractorInterface?

    // MARK: - Init

    init(configure: Configurator<PartnerEditViewController>) {
        super.init(nibName: nil, bundle: nil)
        configure(self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.viewDidLoad()
    }
}

extension PartnerEditViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return view.frame.height * 0.6
        }
        return view.frame.height * 0.4
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell: PartnerEditImageCell = tableView.dequeueCell(for: indexPath)
            cell.configure(imageURL: partner?.imageURL, image: tempImage, interactor: interactor)
            return cell
        }
        let cell: PartnerEditTextFieldCell = tableView.dequeueCell(for: indexPath)
        cell.configure(partner: partner, interactor: interactor)
        return cell
    }
}

// MARK: - Private

private extension PartnerEditViewController {

    func setupTableView() {
        tableView.isScrollEnabled = false
        tableView.backgroundView = UIImageView(image: R.image.backgroundMyToBeVision())
        tableView.separatorColor = .clear
        tableView.contentInset = UIEdgeInsets(top: -64, left: 0, bottom: 0, right: 0)
        tableView.registerDequeueable(PartnerEditImageCell.self)
        tableView.registerDequeueable(PartnerEditTextFieldCell.self)
    }

    func setupNavigationItems() {
        let leftButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(didTapSave))
        leftButton.tintColor = .white30
        navigationItem.leftBarButtonItem = leftButton
        let rightButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didTapCancel))
        rightButton.tintColor = .white30
        navigationItem.rightBarButtonItem = rightButton
    }
}

// MARK: - Actions

private extension PartnerEditViewController {

    @objc func didTapCancel() {
        interactor?.didTapCancel()
    }

    @objc func didTapSave() {
        updatePartner()
        interactor?.didTapSave(partner: partner, image: tempImage)
    }

    func updatePartner() {
        let cell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? PartnerEditTextFieldCell
        partner?.name = cell?.nameTextField.text
        partner?.surname = cell?.surnameTextField.text
        partner?.relationship = cell?.relationshipTextField.text
        partner?.email = cell?.emailTextField.text
    }
}

// MARK: - PartnerEditViewControllerInterface

extension PartnerEditViewController: PartnerEditViewControllerInterface {

    func reload(partner: Partners.Partner) {
        self.partner = partner
    }

    func setupView(partner: Partners.Partner) {
        self.partner = partner
        setupNavigationItems()
        setupTableView()
    }

    func dismiss() {
        let cell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? PartnerEditTextFieldCell
        cell?.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - ImagePickerControllerDelegate

extension PartnerEditViewController: ImagePickerControllerDelegate {

    func imagePickerController(_ imagePickerController: ImagePickerController, selectedImage image: UIImage) {
        tempImage = image
        updatePartner()
        tableView.reloadRows(at: [IndexPath(item: 0, section: 0)], with: .automatic)
    }

    func cancelSelection() {

    }
}
