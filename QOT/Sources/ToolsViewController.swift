//
//  ToolsViewController.swift
//  QOT
//
//  Created by Anais Plancoulaine on 17.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class ToolsViewController: UIViewController, ScreenZLevel3 {

    // MARK: - Properties

    var interactor: ToolsInteractorInterface?
    @IBOutlet private weak var tableView: UITableView!
    private var toolModel: ToolModel?
    private enum CellType: Int, CaseIterable {
        case header = 0
        case sections
    }

    init(configure: Configurator<ToolsViewController>) {
        super.init(nibName: nil, bundle: nil)
        configure(self)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .sand
        setStatusBar(colorMode: ColorMode.darkNot)
        interactor?.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackPage()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? ToolsCollectionsViewController {
            ToolsCollectionsConfigurator.make(viewController: controller, selectedToolID: sender as? Int)
        }
    }
}

// MARK: - Private

private extension ToolsViewController {

    func setupTableView() {
        tableView.registerDequeueable(ToolsTableViewCell.self)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: BottomNavigationContainer.height, right: 0)
    }
}

// MARK: - Bottom Navigation

extension ToolsViewController {
    @objc override public func bottomNavigationLeftBarItems() -> [UIBarButtonItem]? {
        return [dismissNavigationItemLight()]
    }
}

// MARK: - Actions

private extension ToolsViewController {

    @IBAction func closeButton(_ sender: Any) {
        trackUserEvent(.CLOSE, action: .TAP)
        navigationController?.popToRootViewController(animated: true)
    }
}

// MARK: - CoachViewControllerInterface

extension ToolsViewController: ToolsViewControllerInterface {

    func setupView() {
        setupTableView()
        setCustomBackButton()
    }

    func setup(for toolSection: ToolModel) {
        toolModel = toolSection
    }

    func reload() {
        tableView.reloadData()
    }
}

extension ToolsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactor?.tools().count ?? 0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cellType = CellType.allCases[section]
        switch cellType {
        case .header:
            return ToolsTableHeaderView.instantiateFromNib(title: toolModel?.headerTitle ?? "", subtitle: toolModel?.headerSubtitle ?? "")
        default: return nil
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ToolsTableViewCell = tableView.dequeueCell(for: indexPath)
        let toolCount = interactor?.tools()[indexPath.item].itemCount
        let toolNumber = toolCount.map({String($0)})
        let number = toolNumber ?? ""
        cell.configure(title: (toolModel?.toolItems[indexPath.row].title) ?? "", subtitle: number + " tools")
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.accent.withAlphaComponent(0.1)
        cell.selectedBackgroundView = backgroundView
        cell.accessoryView = UIImageView(image: R.image.ic_disclosure_accent())
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         tableView.deselectRow(at: indexPath, animated: true)
        let toolKey = interactor?.tools()[indexPath.item].remoteID
        trackUserEvent(.OPEN, value: toolKey, valueType: .CONTENT, action: .TAP)
        interactor?.presentToolsCollections(selectedToolID: interactor?.tools()[indexPath.item].remoteID)
    }
}
