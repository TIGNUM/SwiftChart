//
//  SettingsAdminViewControllerTableViewController.swift
//  QOT
//
//  Created by karmic on 30.10.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import SwiftyBeaver
import MBProgressHUD

final class SettingsAdminViewController: UITableViewController {

    enum Sections: Int {
        case baseURL = 0
        case sync = 1
        case logLevel = 2
        case dataBase = 3
        case reset = 4
    }

    enum BaseURL: Int {
        case live = 0
        case staging = 1

        var stringValue: String {
            switch self {
            case .live: return "https://esb.tignum.com"
            case .staging: return "https://esb-staging.tignum.com"
            }
        }
    }

    enum DataBase: Int {
        case dataPoints = 0
        case content = 1
        case preparation = 2
        case userPartners = 3
        case userToBeVision = 4
        case guide = 5
    }

    // MARK: - Properties

    @IBOutlet private weak var baseURLTextField: UITextField!
    @IBOutlet private weak var baseURLUpdateButton: UIButton!
    @IBOutlet private weak var baseURLResetButton: UIButton!
    @IBOutlet private weak var baseURLSegmentedControl: UISegmentedControl!
    @IBOutlet private weak var autoSyncSwitch: UISwitch!
    @IBOutlet private weak var logLevelSegmentedControl: UISegmentedControl!
    private var dataBaseTouched = false
    private let userName = CredentialsManager.shared.credential?.username
    private let password = CredentialsManager.shared.credential?.password
    var syncManager: SyncManager?
    var networkManager: NetworkManager?
    var services: Services?
    var networkError: NetworkError?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupNotifications()
    }

    deinit {
        tearDownNotifcations()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupDefaultValues()
    }
}

extension SettingsAdminViewController {

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let section = Sections(rawValue: section) else { return nil }
        switch section {
        case .baseURL: return networkError == nil ? String(format: "Current baseURL: %@", baseURL.absoluteString) : networkError?.localizedDescription
        case .sync: return dataBaseTouched == false ? "sync" : "autoSync is disabled because the dataBase was touched -> U allways can do a reset"
        case .logLevel: return "logLevel: error == default"
        case .dataBase: return "dataBase: an erase will turn off autoSync"
        case .reset: return "reset changes back to default:\n - baseURL\n - sync\n - loglevel\n - downSync fresh data"
        }
    }
}

// MARK: - Private

private extension SettingsAdminViewController {

    private func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(syncAllDidFinishNotification(_:)), name: .syncAllDidFinishNotification, object: nil)
    }

    private func tearDownNotifcations() {
        NotificationCenter.default.removeObserver(self, name: .syncAllDidFinishNotification, object: nil)
    }

    @objc private func syncAllDidFinishNotification(_ notification: Notification) {
        guard let window = AppDelegate.current.window else {
            return
        }
        MBProgressHUD.hide(for: window, animated: true)
    }

    @IBAction private func updateBaseURLTapped(sender: UIButton) {
        guard
            let newBaseURLString = baseURLTextField.text,
            let newBaseURL = URL(string: newBaseURLString) else {
                return
        }

        baseURL = newBaseURL
        reloginUser { [unowned self] in
            self.tableView.reloadData()
        }
    }

    @IBAction private func resetBaseURLTapped(sender: UIButton) {
        baseURL = URL(string: BaseURL.live.stringValue) ?? baseURL
        reloginUser { [unowned self] in
            self.tableView.reloadData()
        }
    }

    @IBAction private func cleanDataBaseTapped(sender: UIButton) {
        guard let dataBaseActionType = DataBase(rawValue: sender.tag) else { return }
        autoSyncSwitch.setOn(false, animated: true)
        autoSyncSwitch.isEnabled = false
        dataBaseTouched = true
        tableView.reloadData()

        switch dataBaseActionType {
        case .dataPoints: eraseDataPoints()
        case .content: eraseConent()
        case .preparation: erasePreparations()
        case .userPartners: erasePreparations()
        case .userToBeVision: eraseUserToBeVision()
        case .guide: eraseGuide()
        }
    }

    @IBAction private func loggLevelChanged(sender: UISegmentedControl) {
        guard let logLevel = SwiftyBeaver.Level(rawValue: sender.selectedSegmentIndex) else { return }
        let remoteLog = RemoteLogDestination()
        remoteLog.minLevel = logLevel
        Log.remoteLogLevel = logLevel
        Log.main.addDestination(remoteLog)
    }

    @IBAction private func baseURLChanged(sender: UISegmentedControl) {
        guard
            let urlString = BaseURL(rawValue: sender.selectedSegmentIndex)?.stringValue,
            let url = URL(string: urlString) else {
                return
        }

        baseURL = url
        reloginUser { [unowned self] in
            self.tableView.reloadData()
        }
    }

    @IBAction private func autoSyncChanged(sender: UISwitch) {
        switch sender.isOn {
        case true:
            syncManager?.start()
        case false:
            syncManager?.stop()
        }
    }

    @IBAction private func syncAllTapped(sender: UIButton) {
        syncData(shouldDownload: true)
    }

    @IBAction private func syncUpTapped(sender: UIButton) {
        syncData(shouldDownload: false)
    }

    @IBAction private func resetToDefaultTapped(sender: UIButton) {
        baseURL = URL(string: BaseURL.live.stringValue)!
        let remoteLog = RemoteLogDestination()
        remoteLog.minLevel = .error
        Log.remoteLogLevel = .error
        Log.main.addDestination(remoteLog)
        autoSyncSwitch.isEnabled = true
        dataBaseTouched = false
        setupDefaultValues()
        syncData(shouldDownload: true)
        tableView.reloadData()
    }
}

private extension SettingsAdminViewController {

    func reloginUser(completion: @escaping () -> Void) {
        guard let userName = userName, let password = password else { return }
        CredentialsManager.shared.clear()
        guard let window = AppDelegate.current.window, let networkManager = networkManager else { return }
        let hud = MBProgressHUD.showAdded(to: window, animated: true)
        networkManager.cancelAllRequests()

        do {
            syncManager?.stop()
            if let syncRecordService = syncManager?.syncRecordService {
                try DatabaseManager.shared.resetDatabase(syncRecordService: syncRecordService)
            }
        } catch {
            log(error.localizedDescription, level: .error)
        }

        networkManager.performAuthenticationRequest(username: userName, password: password) { error in
            hud.hide(animated: true)
            if error == nil {
                self.syncManager?.start()
                completion()
            } else {
                self.networkError = error
                completion()
            }
        }
    }

    func eraseDataPoints() {
        services?.statisticsService.eraseData()
    }

    func eraseConent() {
        services?.contentService.eraseData()
    }

    func erasePreparations() {
        services?.preparationService.eraseData()
    }

    func eraseUserPartners() {
        services?.userService.eraseToBeVision()
    }

    func eraseUserToBeVision() {
        services?.userService.eraseToBeVision()
    }

    func eraseGuide() {
        services?.guideService.eraseGuide()
        services?.guideItemLearnService.eraseItems()
        services?.guideItemNotificationService.eraseItems()
    }

    func syncData(shouldDownload: Bool) {
        guard let window = AppDelegate.current.window else {
            return
        }
        _ = MBProgressHUD.showAdded(to: window, animated: true)
        syncManager?.syncAll(shouldDownload: shouldDownload)
    }

    func setupDefaultValues() {
        baseURLSegmentedControl.selectedSegmentIndex = baseURL.absoluteString.contains("staging") == true ? 1 : 0
        baseURLTextField.text = ""
        logLevelSegmentedControl.selectedSegmentIndex = Log.remoteLogLevel.rawValue
        autoSyncSwitch.setOn(true, animated: true)
    }
}
