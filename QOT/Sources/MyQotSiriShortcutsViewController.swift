//
//  MyQotSiriShortcutsViewController.swift
//  QOT
//
//  Created by Ashish Maheshwari on 14.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import IntentsUI

final class MyQotSiriShortcutsViewController: UIViewController {

    // MARK: - Properties

    var interactor: MyQotSiriShortcutsInteractorInterface?
    private var shortcutType: ShortcutType = .toBeVision
    private var selectedShortCutPage: PageName?
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var headerLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
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
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = .carbon
        interactor?.siriShortcutsHeaderText({[weak self] (text) in
            self?.headerLabel.text = text
        })
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension MyQotSiriShortcutsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactor?.itemsCount() ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TitleTableViewCell = tableView.dequeueCell(for: indexPath)
        cell.config = TitleTableViewCell.Config(backgroundColor: .carbon)
        cell.title = interactor?.title(for: indexPath).uppercased() ?? ""
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        shortcutType = interactor?.shortcutType(for: indexPath).type ?? .toBeVision
        selectedShortCutPage =  interactor?.shortcutType(for: indexPath).type.pageName
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
