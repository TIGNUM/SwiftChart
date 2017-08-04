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

    func didTapLibraryCell(in viewController: SidebarViewController)

    func didTapSettingsMenuCell(with contentCollection: ContentCollection?, in viewController: SidebarViewController)

    func didTapBenefitsCell(with contentCollection: ContentCollection?, in viewController: SidebarViewController)

    func didTapAddSensorCell(with contentCollection: ContentCollection?, in viewController: SidebarViewController)

    func didTapPrivacyCell(with contentCollection: ContentCollection?, in viewController: SidebarViewController)

    func didTapAboutCell(with contentCollection: ContentCollection?, in viewController: SidebarViewController)

    func didTapLogoutCell(in viewController: SidebarViewController)
}

final class SidebarViewController: UIViewController {
    
    // MARK: - Properties

    fileprivate let viewModel: SidebarViewModel
    weak var delegate: SidebarViewControllerDelegate?

    fileprivate lazy var tableView: UITableView = {
        return UITableView(
            delegate: self,
            dataSource: self,
            dequeables:
            SidebarTableViewCell.self
        )
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
        tableView.bounces = false
        tableView.topAnchor == view.topAnchor
        tableView.bottomAnchor == view.bottomAnchor
        tableView.horizontalAnchors == view.horizontalAnchors        
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension SidebarViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.itemCount
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.sidebarItem(at: indexPath)?.cellHeight(screenType: screenType) ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SidebarTableViewCell = tableView.dequeueCell(for: indexPath)
        let sidebarItem = viewModel.sidebarItem(at: indexPath)
        cell.setup(
            with: sidebarItem?.title,
            font: sidebarItem?.font,
            textColor: sidebarItem?.fontColor,
            topAnchor: sidebarItem?.topAnchor(screenType: screenType),
            height: sidebarItem?.cellHeight(screenType: screenType)
        )

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
        guard let sidebarItem = sidebarItem else {
            return
        }

        switch sidebarItem {
        case .about: delegate?.didTapAboutCell(with: viewModel.contentCollection(sidebarItem), in: self)
        case .benefits: delegate?.didTapBenefitsCell(with: viewModel.contentCollection(sidebarItem), in: self)
        case .library: delegate?.didTapLibraryCell(in: self)
        case .logout: delegate?.didTapLogoutCell(in: self)
        case .privacy: delegate?.didTapPrivacyCell(with: viewModel.contentCollection(sidebarItem), in: self)
        case .sensor: delegate?.didTapAddSensorCell(with: viewModel.contentCollection(sidebarItem), in: self)
        case .settings: delegate?.didTapSettingsMenuCell(with: viewModel.contentCollection(sidebarItem), in: self)
        }
    }
}
