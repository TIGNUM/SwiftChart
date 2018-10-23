//
//  SidebarViewController.swift
//  QOT
//
//  Created by karmic on 20/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit
import Anchorage

protocol SidebarViewControllerDelegate: class {

    func didTapSearchCell(in viewController: SidebarViewController)
    func didTapLibraryCell(in viewController: SidebarViewController)
    func didTapSupportCell(in viewController: SidebarViewController)
    func didTapSettingsCell(in viewController: SidebarViewController)
    func didTapAdminCell(in viewController: SidebarViewController)
    func didTapProfileCell(with contentCollection: ContentCollection?,
                           in viewController: SidebarViewController,
                           options: [LaunchOption: String?]?)
    func didTapAboutCell(in viewController: SidebarViewController)
}

final class SidebarViewController: UIViewController {

    // MARK: - Properties

    private let viewModel: SidebarViewModel
    weak var delegate: SidebarViewControllerDelegate?

    private lazy var tableView: UITableView = {
        return UITableView(delegate: self,
                           dataSource: self,
                           dequeables: SidebarTableViewCell.self)
    }()

    private lazy var versionLabel: UILabel = {
        let label = UILabel()
        let text = Bundle.main.versionAndBuildNumber
        label.attributedText = Style.tag(text, .white20).attributedString(alignment: .center)
        return label
    }()

    // MARK: - Life Cycle

    init(viewModel: SidebarViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}

// MARK: - Private

private extension SidebarViewController {

    func setupView() {
        view.addSubview(tableView)
        view.addSubview(versionLabel)
        versionLabel.bottomAnchor == view.safeBottomAnchor - Layout.padding_24
        versionLabel.heightAnchor == Layout.height_44
        versionLabel.horizontalAnchors == view.horizontalAnchors
        tableView.topAnchor == view.safeTopAnchor
        tableView.horizontalAnchors == view.horizontalAnchors
        tableView.bottomAnchor == versionLabel.topAnchor
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension SidebarViewController: UITableViewDelegate, UITableViewDataSource, PageViewControllerNotSwipeable {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.itemCount
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.sidebarItem(at: indexPath)?.cellHeight(screenType: screenType) ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SidebarTableViewCell = tableView.dequeueCell(for: indexPath)
        let sidebarItem = viewModel.sidebarItem(at: indexPath)
        cell.setup(with: sidebarItem?.title,
                   font: sidebarItem?.font(screenType: screenType),
                   textColor: sidebarItem?.fontColor,
                   height: sidebarItem?.cellHeight(screenType: screenType))

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        handleSelection(sidebarItem: viewModel.sidebarItem(at: indexPath))
    }
}

// MARK: - Selection

private extension SidebarViewController {

    func handleSelection(sidebarItem: SidebarViewModel.SidebbarItem?) {
        guard let sidebarItem = sidebarItem else { return }

        switch sidebarItem {
        case .search: delegate?.didTapSearchCell(in: self)
        case .tools: delegate?.didTapLibraryCell(in: self)
        case .profile:
            delegate?.didTapProfileCell(with: viewModel.contentCollection(sidebarItem),
                                        in: self,
                                        options: nil)
        case .placeholder: return
        case .support: delegate?.didTapSupportCell(in: self)
        case .about: delegate?.didTapAboutCell(in: self)
        case .settings: delegate?.didTapSettingsCell(in: self)
        case .admin: delegate?.didTapAdminCell(in: self)
        }
    }
}
