//
//  MyQotSiriShortcutsViewController.swift
//  QOT
//
//  Created by Ashish Maheshwari on 14.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import IntentsUI

final class MyQotSiriShortcutsViewController: BaseViewController, ScreenZLevel3 {

    // MARK: - Properties

    var interactor: MyQotSiriShortcutsInteractorInterface?
    private var shortcutType: ShortcutType = .toBeVision
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var headerLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        ThemeView.level3.apply(view)
        interactor?.viewDidLoad()
        tableView.registerDequeueable(TitleTableViewCell.self)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackPage()
    }
}

extension MyQotSiriShortcutsViewController: MyQotSiriShortcutsViewControllerInterface {

    func setupView() {
        ThemeView.level3.apply(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        ThemeText.myQOTSectionHeader.apply(interactor?.siriShortcutsHeaderText, to: headerLabel)
        tableView.reloadData()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension MyQotSiriShortcutsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactor?.itemsCount() ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TitleTableViewCell = tableView.dequeueCell(for: indexPath)
        cell.configure(title: interactor?.title(for: indexPath).uppercased() ?? "",
                       bkgdTheme: .level3, titleTheme: .myQOTTitle)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        shortcutType = interactor?.shortcutType(for: indexPath).type ?? .toBeVision
        let key =  interactor?.trackingKey(for: indexPath)
        trackUserEvent(.OPEN, valueType: key, action: .TAP)
        interactor?.handleTap(for: interactor?.shortcutType(for: indexPath))
    }
}

// MARK: - INUIAddVoiceShortcutViewControllerDelegate

extension MyQotSiriShortcutsViewController: INUIAddVoiceShortcutViewControllerDelegate {

    @available(iOS 12.0, *)
    func addVoiceShortcutViewController(_ controller: INUIAddVoiceShortcutViewController,
                                        didFinishWith voiceShortcut: INVoiceShortcut?,
                                        error: Error?) {
        interactor?.sendSiriRecordingAppEvent(shortcutType: shortcutType)
        dismiss(animated: true, completion: nil)
    }

    @available(iOS 12.0, *)
    func addVoiceShortcutViewControllerDidCancel(_ controller: INUIAddVoiceShortcutViewController) {
        dismiss(animated: true, completion: nil)
    }
}
