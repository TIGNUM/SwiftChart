//
//  SettingsBubblesViewController.swift
//  QOT
//
//  Created by Javier Sanz Rozalen on 12/04/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit
import Anchorage

final class SettingsBubblesViewController: UIViewController {

    @IBOutlet weak var bubblesView: BubblesView!
    private var settingsType: SettingsBubblesType?
    var interactor: SettingsBubblesInteractorInterface?

    init(configurator: Configurator<SettingsBubblesViewController>, settingsType: SettingsBubblesType) {
        super.init(nibName: nil, bundle: nil)
        self.settingsType = settingsType
        configurator(self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .navy
        bubblesView.selectionDelegate = self
        bubblesView.type = settingsType
        setupNavigationBar()
    }
}

// MARK: - Private

private extension SettingsBubblesViewController {

    func setupNavigationBar() {
        let title = settingsType == .about ? R.string.localized.sidebarTitleAbout() : R.string.localized.sidebarTitleSupport()
        navigationItem.title = title.uppercased()
    }
}

// MARK: - SettingsBubblesViewControlerInterface

extension SettingsBubblesViewController: SettingsBubblesViewControllerInterface {

    func load(bubbleTapped: SettingsBubblesModel.SettingsBubblesItem) {

    }
}

// MARK: - BubblesViewSelectionDelegate

extension SettingsBubblesViewController: BubblesViewSelectionDelegate {

    func didTouchUp(settingsType: SettingsBubblesModel.SettingsBubblesItem, in view: BubblesView) {
        interactor?.handleSelection(bubbleTapped: settingsType)
    }
}
