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
    func didTapSettingsMenuCell(in viewController: SidebarViewController)
    func didTapLibraryCell(in viewController: SidebarViewController)
    func didTapBenefitsCell(from sidebarContentCategory: SidebarContentCategory, in viewController: SidebarViewController)
    func didTapAddSensorCell(in viewController: SidebarViewController)
    func didTapPrivacyCell(from sidebarContentCategory: SidebarContentCategory, in viewController: SidebarViewController)
    func didTapAboutCell(from sidebarContentCategory: SidebarContentCategory, in viewController: SidebarViewController)
    func didTapLogoutCell(in viewController: SidebarViewController)
}

final class SidebarViewController: UIViewController {
    
    // MARK: - Properties

    fileprivate let viewModel: SidebarViewModel
    weak var delegate: SidebarViewControllerDelegate?

    fileprivate lazy var tableView: UITableView = {
        return UITableView(
            estimatedRowHeight: 10,
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
        return viewModel.sidebarCategory(at: indexPath.row).cellHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Layout.CellHeight.sidebarHeader.rawValue
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SidebarTableViewCell = tableView.dequeueCell(for: indexPath)
        let item = viewModel.sidebarCategory(at: indexPath.row)
        cell.setup(with: item.title, font: item.font, textColor: item.textColor)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        handleSelection(forSidbarCollection: viewModel.sidebarCategory(at: indexPath.row))
    }
}

// MARK: - Selection

extension SidebarViewController {
    
    fileprivate func handleSelection(forSidbarCollection sidebarCategory: SidebarContentCategory?) {
        guard
            let sidebarCategory = sidebarCategory,
            let keypathID = sidebarCategory.keypathID,
            let section = Database.Section.Sidebar(rawValue: keypathID) else {
                return
        }

        switch section {
        case .about: delegate?.didTapAboutCell(from: sidebarCategory, in: self)
        case .benefits: delegate?.didTapBenefitsCell(from: sidebarCategory, in: self)
        case .library: delegate?.didTapLibraryCell(in: self)
        case .logout: delegate?.didTapLogoutCell(in: self)
        case .privacy: delegate?.didTapPrivacyCell(from: sidebarCategory, in: self)
        case .sensor: delegate?.didTapAddSensorCell(in: self)
        case .settings: delegate?.didTapSettingsMenuCell(in: self)
        }
    }
}
