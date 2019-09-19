//
//  PreparationWithMissingEventViewController.swift
//  QOT
//
//  Created by Sanggeon Park on 18.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class PreparationWithMissingEventViewController: BaseWithTableViewController, ScreenZLevel3 {

    // MARK: - Properties
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    private var removeButtonItem = UIBarButtonItem()
    private var keepButtonItem = UIBarButtonItem()

    var interactor: PreparationWithMissingEventInteractorInterface?

    // MARK: - Init

    init(configure: Configurator<PreparationWithMissingEventViewController>) {
        super.init(nibName: nil, bundle: nil)
        configure(self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.viewDidLoad()
        setupView()
    }
}

// MARK: - Private

private extension PreparationWithMissingEventViewController {

    func setupView() {
        tableView.tableFooterView = UIView()
        tableView.registerDequeueable(PrepareEventTableViewCell.self)
        ThemeView.qotTools.apply(view)
        ThemeView.qotTools.apply(tableView)
        setStatusBar(colorMode: ColorMode.darkNot)
    }
}

// MARK: - Bottom Navigation

extension PreparationWithMissingEventViewController {

    override public func bottomNavigationLeftBarItems() -> [UIBarButtonItem]? {
        return []
    }

    override public func bottomNavigationRightBarItems() -> [UIBarButtonItem]? {
        return [removeButtonItem, keepButtonItem]
    }
}

// MARK: - Actions

private extension PreparationWithMissingEventViewController {
    @objc func didTapKeepButton(_ sender: Any?) {
        trackUserEvent(.KEEP_PREPARATION_WITH_MISSING_EVENT,
                       value: interactor?.preparationRemoteId(),
                       stringValue: interactor?.preparationTitle(),
                       valueType: .USER_PREPARATION,
                       action: .TAP)
        interactor?.keepPreparation()
    }

    @objc func didTapDeleteButton(_ sender: Any?) {
        trackUserEvent(.DELETE_PREPARATION_WITH_MISSING_EVENT,
                       value: interactor?.preparationRemoteId(),
                       stringValue: interactor?.preparationTitle(),
                       valueType: .USER_PREPARATION,
                       action: .TAP)
        interactor?.deletePreparation()
    }
}

// MARK: - PreparationWithMissingEventViewControllerInterface

extension PreparationWithMissingEventViewController: PreparationWithMissingEventViewControllerInterface {
    func reloadEvents() {
        tableView.reloadData()
    }

    func update(title: String, text: String, removeButtonTitle: String, keepButtonTitle: String) {
        removeButtonItem = roundedBarButtonItem(title: removeButtonTitle,
                                                buttonWidth: .Remove,
                                                action: #selector(didTapDeleteButton(_:)))
        keepButtonItem = roundedBarButtonItem(title: keepButtonTitle,
                                              buttonWidth: .Keep,
                                              action: #selector(didTapKeepButton(_:)))
        ThemeText.qotToolsTitle.apply(title, to: titleLabel)
        ThemeText.qotToolsSubtitle.apply(text, to: descriptionLabel)
        var pageTrack = QDMPageTracking()
        pageTrack.pageId = 0
        pageTrack.pageKey = pageKey
        pageTrack.associatedValueId = interactor?.preparationRemoteId()
        pageTrack.associatedValueType = .PREPARATION
        NotificationCenter.default.post(name: .reportPageTracking, object: pageTrack)
    }
}

// MARK: - UITableViewDataSource

extension PreparationWithMissingEventViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactor?.eventCount() ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let event = interactor?.eventAt(indexPath.row)
        let cell: PrepareEventTableViewCell = tableView.dequeueCell(for: indexPath)
        cell.configure(title: event?.title, dateString: Prepare.dateString(for: event?.startDate))
        return cell
    }
}

// MARK: - UITableViewDelegate

extension PreparationWithMissingEventViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        trackUserEvent(.PREPARATION_ASSIGN_NEW_EVENT,
                       value: interactor?.preparationRemoteId(),
                       stringValue: interactor?.preparationTitle(),
                       valueType: .USER_PREPARATION,
                       action: .TAP)
        didSelectRow(at: indexPath)
        interactor!.updatePreparation(with: interactor!.eventAt(indexPath.row))
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
}
