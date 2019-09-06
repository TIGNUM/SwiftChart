//
//  SiriShortcutsViewController.swift
//  QOT
//
//  Created by Anais Plancoulaine on 08.02.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import IntentsUI

final class SiriShortcutsViewController: UIViewController {

    // MARK: - Properties

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var explanationLabel: UILabel!
    private var siriShortcutsModel: SiriShortcutsModel?
    var interactor: SiriShortcutsInteractorInterface?
    private var shortcutType: ShortcutType = .toBeVision
    var selectedShortCutPage: PageName?

     // MARK: - Init

    init(configure: Configurator<SiriShortcutsViewController>, services: Services) {
        super.init(nibName: nil, bundle: nil)
        configure(self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = R.string.localized.settingsSiriShortcutsTitle()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        selectedShortCutPage = nil
        interactor?.viewDidLoad()
        tableView.registerDequeueable(SiriShortcutsCell.self)
        setCustomBackButton()
    }
}

 // MARK: - SiriShortcutsViewControllerInterface

extension SiriShortcutsViewController: SiriShortcutsViewControllerInterface {

    func setup(for shortcut: SiriShortcutsModel) {
        view.backgroundColor = .navy
        siriShortcutsModel = shortcut
        explanationLabel.text = siriShortcutsModel?.explanation
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension SiriShortcutsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return siriShortcutsModel?.shortcuts.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SiriShortcutsCell = tableView.dequeueCell(for: indexPath)
        cell.accessoryType = .disclosureIndicator
        cell.configure(title: siriShortcutsModel?.shortcuts[indexPath.row].title)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        shortcutType = siriShortcutsModel?.shortcuts[indexPath.row].type ?? .toBeVision
        selectedShortCutPage = shortcutType.pageName
        interactor?.handleTap(for: siriShortcutsModel?.shortcuts[indexPath.row])
    }
}

// MARK: - INUIAddVoiceShortcutViewControllerDelegate

extension SiriShortcutsViewController: INUIAddVoiceShortcutViewControllerDelegate {

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
