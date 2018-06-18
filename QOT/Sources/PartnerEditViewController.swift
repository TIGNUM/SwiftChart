//
//  PartnerEditViewController.swift
//  QOT
//
//  Created by karmic on 12.05.18.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import UIKit

enum PartnerCellType: Int {
    case partnerImage = 0
    case partnerInfo
    case partnerDelete
}

final class PartnerEditViewController: UITableViewController {

    // MARK: - Constants

    private var partnerImageHeightRatio: CGFloat = 0.6
    private var partnerInfoHeightRatio: CGFloat = 0.4
    private var partnerDeleteHeightRatio: CGFloat = 0.1
    private var infoCellVerticalSpace: CGFloat = 15

    // MARK: - Properties

    private var partner: Partners.Partner?
    private var tempImage: UIImage?
    private var showsDeleteButton: Bool = true
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

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateInfoCellVerticalSpacing()
    }
}

extension PartnerEditViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showsDeleteButton ? 3 : 2
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let viewHeight = view.frame.height - view.safeMargins.bottom
        switch PartnerCellType(rawValue: indexPath.row)! {
        case .partnerImage:
            return viewHeight * partnerImageHeightRatio
        case .partnerDelete:
            return viewHeight * partnerDeleteHeightRatio
        default:
            break
        }
        return viewHeight * partnerInfoHeightRatio
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch PartnerCellType(rawValue: indexPath.row)! {
        case .partnerImage:
            let cell: PartnerEditImageCell = tableView.dequeueCell(for: indexPath)
            cell.configure(imageURL: partner?.imageURL, image: tempImage, interactor: interactor)
            return cell
        case .partnerDelete:
            let cell: PartnerEditDeleteButtonCell = tableView.dequeueCell(for: indexPath)
            cell.configure(partner: partner, interactor: interactor)
            return cell
        default:
            break
        }
        let cell: PartnerEditTextFieldCell = tableView.dequeueCell(for: indexPath)
        cell.configure(partner: partner, interactor: interactor, verticalSpace: infoCellVerticalSpace)
        return cell
    }
}

// MARK: - Private

private extension PartnerEditViewController {

    func setupTableView() {
        tableView.bounces = false
        tableView.isScrollEnabled = false
        tableView.backgroundView = UIImageView(image: R.image.backgroundMyToBeVision())
        tableView.backgroundColor = .white
        tableView.backgroundView?.alpha = 0.9
        tableView.separatorColor = .clear
        tableView.registerDequeueable(PartnerEditImageCell.self)
        tableView.registerDequeueable(PartnerEditTextFieldCell.self)
        tableView.registerDequeueable(PartnerEditDeleteButtonCell.self)
        tableView.separatorStyle = .none
        if #available(iOS 11, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func setupNavigationItems() {
        let leftButton = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(didTapCancel))
        leftButton.tintColor = .white30
        navigationItem.leftBarButtonItem = leftButton
        let rightButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(didTapSave))
        rightButton.tintColor = .white30
        navigationItem.rightBarButtonItem = rightButton
    }

    func setupCellHeights() {
        partnerDeleteHeightRatio = showsDeleteButton ? partnerDeleteHeightRatio : 0
        partnerInfoHeightRatio = partnerInfoHeightRatio - partnerDeleteHeightRatio
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

    func updateInfoCellVerticalSpacing() {
        let infoCellHeight = view.frame.height * partnerInfoHeightRatio
        let newHeight: CGFloat = (infoCellHeight - (40.0 * 4.0))/5.0
        if infoCellVerticalSpace != newHeight {
            infoCellVerticalSpace = newHeight
            let cellType = PartnerCellType.partnerInfo
            tableView.reloadRows(at: [IndexPath(row: cellType.rawValue, section: 0)], with: .none)
        }
    }
}

// MARK: - PartnerEditViewControllerInterface

extension PartnerEditViewController: PartnerEditViewControllerInterface {

    func reload(partner: Partners.Partner) {
        self.partner = partner
    }

    func setupView(partner: Partners.Partner, isNewPartner: Bool) {
        self.partner = partner
        self.showsDeleteButton = isNewPartner ? false : true

        setupNavigationItems()
        setupTableView()
        setupCellHeights()
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
