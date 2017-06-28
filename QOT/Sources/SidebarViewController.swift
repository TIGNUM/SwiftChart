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
    func didTapLibraryCell(contentCollections: [ContentCollection], in viewController: SidebarViewController)
    func didTapSettingsMenuCell(contentCollections: [ContentCollection], in viewController: SidebarViewController)
    func didTapBenefitsCell(contentCollections: [ContentCollection], in viewController: SidebarViewController)
    func didTapAddSensorCell(contentCollections: [ContentCollection],in viewController: SidebarViewController)
    func didTapPrivacyCell(contentCollections: [ContentCollection], in viewController: SidebarViewController)
    func didTapAboutCell(contentCollections: [ContentCollection], in viewController: SidebarViewController)
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
        return viewModel.sidebarItem(at: indexPath)?.cellHeight ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableView.frame.height <= 632 ? 0 : Layout.CellHeight.sidebarHeader.rawValue
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SidebarTableViewCell = tableView.dequeueCell(for: indexPath)
        let sidebarItem = viewModel.sidebarItem(at: indexPath)
        cell.setup(with: sidebarItem?.title, font: sidebarItem?.font, textColor: sidebarItem?.fontColor)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        handleSelection(sidebar: viewModel.sidebarItem(at: indexPath))
    }
}

// MARK: - Selection

private extension SidebarViewController {
    
    func handleSelection(sidebar: SidebarViewModel.Sidebbar?) {
        guard let sidebar = sidebar else {
            return
        }

        switch sidebar {
        case .about: delegate?.didTapAboutCell(contentCollections: [], in: self)
        case .benefits: delegate?.didTapBenefitsCell(contentCollections: [], in: self)
        case .library: delegate?.didTapLibraryCell(contentCollections: [], in: self)
        case .logout: delegate?.didTapLogoutCell(in: self)
        case .privacy: delegate?.didTapPrivacyCell(contentCollections: [], in: self)
        case .sensor: delegate?.didTapAddSensorCell(contentCollections: [], in: self)
        case .settings: delegate?.didTapSettingsMenuCell(contentCollections: [], in: self)
        }
    }
}
