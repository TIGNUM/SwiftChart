//
//  MyQOTAdminEditSprintsDetailsViewController.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 19/12/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class MyQOTAdminEditSprintsDetailsViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var headerView: UIView!
    @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
    private var baseHeaderView: QOTBaseHeaderView?
    let datePicker = UIDatePicker()
    var currentTextField: UITextField?
    var currentProperty: SprintEditObject?

    var interactor: MyQOTAdminEditSprintsDetailsInteractorInterface!
    private lazy var router: MyQOTAdminEditSprintsDetailsRouter! = MyQOTAdminEditSprintsDetailsRouter(viewController: self)

    // MARK: - Init

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor.viewDidLoad()
        baseHeaderView = R.nib.qotBaseHeaderView.firstView(owner: self)
        baseHeaderView?.addTo(superview: headerView)
        setupTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ThemeView.level2.apply(UIApplication.shared.statusBarView ?? UIView())
    }

    @objc func doneAction() {
        interactor.updateSprint(completion: { [weak self] in
            self?.router.dismiss()
        })
    }
}

// MARK: - Private
private extension MyQOTAdminEditSprintsDetailsViewController {
    func setupTableView() {
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(didTap))
        view.addGestureRecognizer(tapGesture)
        ThemeView.level2.apply(view)
        ThemeView.level2.apply(tableView)
        ThemeView.level2.apply(headerView)
        tableView.registerDequeueable(MyQOTAdminEditSprintsDetailsTableViewCell.self)
        ThemeView.level2.apply(self.view)
        baseHeaderView?.configure(title: interactor.getHeaderTitle(),
                                  subtitle: nil)
        headerViewHeightConstraint.constant = baseHeaderView?.calculateHeight(for: headerView.frame.size.width) ?? 0

        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = UIView.headerView(with: .level2)
        tableView.allowsSelection = false
        tableView.reloadData()
    }

    @objc func didTap() {
        self.view.endEditing(true)
    }
}

// MARK: - TableView delegates
extension MyQOTAdminEditSprintsDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactor.getDatasourceCount()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MyQOTAdminEditSprintsDetailsTableViewCell = tableView.dequeueCell(for: indexPath)
        let datasourceObject = interactor.getDatasourceObject(at: indexPath.row)
        cell.configure(datasourceObject)
        cell.delegate = self
        return cell
    }
}

// MARK: - MyQOTAdminEditSprintsDetailsViewControllerInterface
extension MyQOTAdminEditSprintsDetailsViewController: MyQOTAdminEditSprintsDetailsViewControllerInterface, MyQOTAdminEditSprintsDetailsTableViewCellDelegate {
    func didChangeProperty(_ property: SprintEditObject?) {
        guard let prop = property else { return }
        currentProperty = property
        interactor.editSprints(property: prop)
    }

    func didBegiEditing(cell: MyQOTAdminEditSprintsDetailsTableViewCell, _ property: SprintEditObject?) {
        guard let value = property?.value as? Date else {
            currentTextField?.inputAccessoryView = nil
            currentTextField?.inputView = nil
            return
        }
        currentProperty = property
        currentTextField = cell.detailTextField
        showDatePicker(withDate: value)
    }

    func showDatePicker(withDate: Date) {
        datePicker.datePickerMode = .date
        datePicker.date = withDate
        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        //done button & cancel button
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneDatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker))
        toolbar.setItems([doneButton, spaceButton, cancelButton], animated: false)

        currentTextField?.inputAccessoryView = toolbar
        currentTextField?.inputView = datePicker
    }

    @objc func doneDatePicker() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        currentTextField?.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
        currentProperty?.value = datePicker.date
        guard let property = currentProperty else { return }
        interactor.editSprints(property: property)
      }

    @objc func cancelDatePicker() {
        self.view.endEditing(true)
    }

    func setupView() {
        let rightButtons = [roundedBarButtonItem(title: interactor.getDoneButtonTitle(),
                                               buttonWidth: .Done,
                                               action: #selector(doneAction),
                                               backgroundColor: .black,
                                               borderColor: .white)]
        updateBottomNavigation([backNavigationItem()], rightButtons)
    }
}
