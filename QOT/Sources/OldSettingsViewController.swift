//
//  SettingsViewController.swift
//  QOT
//
//  Created by karmic on 20/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Anchorage
import ActionSheetPicker_3_0
import UserNotifications
import UserNotificationsUI
import CoreLocation

//FIXME: Remove when nothing is calling this (Notifications still do)
final class OldSettingsViewController: UIViewController {

    // MARK: - Properties

    private var viewModel: SettingsViewModel
    private let services: Services
    private var tableView: UITableView!
    private let locationManager = CLLocationManager()
    private var pickerViewHeight: NSLayoutConstraint?
    private var destination: AppCoordinator.Router.Destination?
    private var pickerItems: UserMeasurement?
    private var pickerInitialSelection = [Index]()
    private var pickerIndexPath = IndexPath(item: 0, section: 0)
    private let fadeContainerView = FadeContainerView()
    let settingsType: SettingsType.SectionType

    lazy var pickerContentView: UIView = {
        let pickerContentView = UIView()
        pickerContentView.backgroundColor = .white
        return pickerContentView
    }()

    lazy var pickerToolBar: UIToolbar = {
        let toolBar = UIToolbar()
        toolBar.barTintColor = .white
        let cancelButton = UIBarButtonItem(title: R.string.localized.alertButtonTitleCancel(),
                                           style: .plain,
                                           target: self,
                                           action: #selector(pickerViewCancelButtonTapped))
        let doneButton = UIBarButtonItem(title: R.string.localized.morningControllerDoneButton(),
                                           style: .plain,
                                           target: self,
                                           action: #selector(pickerViewDoneButtonTapped))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolBar.setItems([cancelButton, flexibleSpace, doneButton], animated: false)
        return toolBar
    }()

    lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.showsSelectionIndicator = true
        return pickerView
    }()

    // MARK: - Init

    init(viewModel: SettingsViewModel,
         services: Services,
         settingsType: SettingsType.SectionType,
         destination: AppCoordinator.Router.Destination?) {
        self.viewModel = viewModel
        self.settingsType = settingsType
        self.services = services
        self.destination = destination
        super.init(nibName: nil, bundle: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reloadTableView(_:)),
                                               name: .UIApplicationWillEnterForeground,
                                               object: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        registerCells()
    }

    @available(iOS 11.0, *)
    override func viewLayoutMarginsDidChange() {
        super.viewLayoutMarginsDidChange()
        tableView.contentInset = UIEdgeInsets(top: view.safeMargins.top + Layout.statusBarHeight,
                                              left: 0,
                                              bottom: 0,
                                              right: 0)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = settingsType.title.uppercased()
        tableView.reloadData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard destination != nil else { return }
        destination = nil
    }

    @objc func reloadTableView(_ notification: Notification) {
        tableView.reloadData()
    }
}

private extension OldSettingsViewController {

    @objc func pickerViewCancelButtonTapped(_ sender: UIBarButtonItem) {
        hidePickerView()
    }

    @objc func pickerViewDoneButtonTapped(_ sender: UIBarButtonItem) {
        hidePickerView()
    }

    func hidePickerView() {
        UIView.animate(withDuration: 0.6) {
            self.pickerViewHeight?.constant = 0
        }
    }

    func showPickerView() {
        UIView.animate(withDuration: 0.6, animations: {
            self.pickerViewHeight?.constant = self.view.frame.height * 0.3
        }, completion: { finished in
            self.pickerView.selectRow(self.pickerInitialSelection[0], inComponent: 0, animated: false)
            self.pickerView.selectRow(self.pickerInitialSelection[1], inComponent: 1, animated: false)
        })
    }
}

// MARK: - Layout

private extension OldSettingsViewController {

    func setupView() {
        view.addBlackNavigationView()
        tableView = UITableView(frame: .zero, style: .grouped)
        automaticallyAdjustsScrollViewInsets = false
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
            tableView.contentInset.top = view.safeMargins.top + Layout.statusBarHeight + Layout.padding_24
        }
		view.addSubview(fadeContainerView)
		fadeContainerView.addSubview(tableView)
		fadeContainerView.addSubview(pickerContentView)
		pickerContentView.addSubview(pickerToolBar)
        pickerContentView.addSubview(pickerView)
		fadeContainerView.edgeAnchors == view.edgeAnchors
        tableView.edgeAnchors == fadeContainerView.edgeAnchors
        tableView.backgroundView = UIImageView(image: R.image.backgroundSidebar())
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.separatorColor = .clear
		tableView.backgroundColor = .clear
        tableView.allowsSelection = true
        tableView.rowHeight = 44
		tableView.isScrollEnabled = false
        pickerContentView.trailingAnchor == fadeContainerView.trailingAnchor
        pickerContentView.leadingAnchor == fadeContainerView.leadingAnchor
        pickerContentView.bottomAnchor == fadeContainerView.safeBottomAnchor
        pickerViewHeight = pickerContentView.heightAnchor == 0
        pickerToolBar.topAnchor == pickerContentView.topAnchor
        pickerToolBar.leadingAnchor == pickerContentView.leadingAnchor
        pickerToolBar.trailingAnchor == pickerContentView.trailingAnchor
        pickerToolBar.heightAnchor == 45
        pickerView.topAnchor == pickerToolBar.bottomAnchor
        pickerView.leadingAnchor == pickerContentView.leadingAnchor
        pickerView.trailingAnchor == pickerContentView.trailingAnchor
        pickerView.bottomAnchor == pickerContentView.bottomAnchor
        pickerToolBar.tintColor = .clear
        if #available(iOS 11.0, *) {
        } else {
            tableView.contentInset.top = Layout.statusBarHeight + Layout.padding_20
        }
        if let navigationBarHeight = navigationController?.navigationBar.bounds.height {
            fadeContainerView.setFade(top: navigationBarHeight + 32, bottom: 0)
        }
    }

    func registerCells() {
        tableView.register(R.nib.settingsLabelTableViewCell(),
                           forCellReuseIdentifier: R.reuseIdentifier.settingsTableViewCell_Label.identifier)
        tableView.register(R.nib.settingsButtonTableViewCell(),
                           forCellReuseIdentifier: R.reuseIdentifier.settingsTableViewCell_Button.identifier)
        tableView.register(R.nib.settingsControlTableViewCell(),
                           forCellReuseIdentifier: R.reuseIdentifier.settingsTableViewCell_Control.identifier)
        tableView.register(R.nib.settingsTextFieldTableViewCell(),
                           forCellReuseIdentifier: R.reuseIdentifier.settingsTableViewCell_TextField.identifier)
    }

    func updateViewModelAndReloadTableView() {
        guard let settingsViewModel = SettingsViewModel(services: services, settingsType: settingsType) else {
            return
        }
        viewModel = settingsViewModel
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension OldSettingsViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sectionCount
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection(in: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let settingsRow = viewModel.row(at: indexPath)
        guard let settingsCell = tableView.dequeueReusableCell(withIdentifier: settingsRow.identifier, for: indexPath) as? SettingsTableViewCell else {
            fatalError("SettingsTableViewCell DOES NOT EXIST!!!")
        }
        settingsCell.settingsDelegate = self
        settingsCell.setup(settingsRow: settingsRow, indexPath: indexPath, isSyncFinished: true)
        return settingsCell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 28
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 44
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView()
        footer.backgroundColor = .clear
        return footer
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let identifier = R.reuseIdentifier.settingsTableViewCell_Label.identifier
        guard let headerCell = tableView.dequeueReusableCell(withIdentifier: identifier) as? SettingsTableViewCell else {
            fatalError("HeaderCell does not exist!")
        }
        headerCell.setupHeaderCell(title: viewModel.headerTitle(in: section))
        return headerCell.contentView
    }
}

// MARK: - SettingsViewControllerDelegate

extension OldSettingsViewController: SettingsViewControllerDelegate {

    func didTextFieldEndEditing(at indexPath: IndexPath, text: String) {}

    func presentResetPasswordController() {}

    func didTextFieldChanged(at indexPath: IndexPath, text: String) {
        switch indexPath.row {
        case 1: if text.isEmpty == false { viewModel.updateJobTitle(title: text) }
        case 3: if text.isPhoneNumber { viewModel.updateTelephone(telephone: text) }
        default: return
        }
        self.updateViewModelAndReloadTableView()
    }

    func didChangeNotificationValue(sender: UISwitch, settingsCell: SettingsTableViewCell, key: String?) {
        guard let key = key else { return }
        viewModel.updateNotificationSetting(key: key, value: sender.isOn)
    }
}
