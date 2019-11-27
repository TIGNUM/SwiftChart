//
//  ToolsViewController.swift
//  QOT
//
//  Created by Anais Plancoulaine on 17.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class ToolsViewController: BaseViewController, ScreenZLevel3 {

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
        ThemeView.qotTools.apply(view)
        ThemeView.qotTools.apply(tableView)
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
        tableView.tableFooterView = UIView()
        tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        tableView.estimatedSectionHeaderHeight = 60
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
            return ToolsTableHeaderView.init(title: toolModel?.headerTitle?.uppercased() ?? "", subtitle: nil)
        default: return nil
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let tools = interactor?.tools(),
            indexPath.row < tools.count else { return UITableViewCell() }

        let cell: ToolsTableViewCell = tableView.dequeueCell(for: indexPath)
        let toolCount = tools[indexPath.item].itemCount
        cell.configure(title: (toolModel?.toolItems[indexPath.row].title) ?? "", subtitle: "\(toolCount) tools")
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.accent.withAlphaComponent(0.1)
        cell.selectedBackgroundView = backgroundView
        cell.accessoryView = UIImageView(image: R.image.ic_disclosure_accent())
        cell.addTopLine(for: indexPath.row)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         tableView.deselectRow(at: indexPath, animated: true)
        let toolKey = interactor?.tools()[indexPath.item].remoteID
        trackUserEvent(.OPEN, value: toolKey, valueType: .CONTENT, action: .TAP)
        interactor?.presentToolsCollections(selectedToolID: interactor?.tools()[indexPath.item].remoteID)
    }
}
