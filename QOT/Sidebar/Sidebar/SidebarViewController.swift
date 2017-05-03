//
//  SidebarViewController.swift
//  QOT
//
//  Created by karmic on 20/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit

protocol SidebarViewControllerDelegate: class {
    func didTapSettingsMenuCell(in viewController: SidebarViewController)
    func didTapLibraryCell(in viewController: SidebarViewController)
    func didTapBenefitsCell(in viewController: SidebarViewController)
    func didTapPrivacyCell(in viewController: SidebarViewController)
    func didTapAboutCell(in viewController: SidebarViewController)
}

final class SidebarViewController: UIViewController {
    
    // MARK: - Properties

    weak var delegate: SidebarViewControllerDelegate?
    let viewModel: SidebarViewModel
    let cellIdentifier = R.reuseIdentifier.sidebarTableViewCell_Id.identifier
    
    // MARK: - Life Cycle
    
    init(viewModel: SidebarViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
    }
}

// MARK: - Private

private extension SidebarViewController {

    func setupTableView() {        
        let cellNib = UINib(nibName: R.nib.sidebarTableViewCell.name, bundle: nil)
        let tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.bounces = false
        tableView.register(cellNib, forCellReuseIdentifier: cellIdentifier)
        tableView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 64, right: 0)
        view.addSubview(tableView)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension SidebarViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.itemCount
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.item(at: indexPath.row).cellHeight
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SidebarTableViewCell else {
            fatalError("tableView.cellForRowAt dequeueReusableCell SidebarTableViewCell does not exist!")
        }
        
        let item = viewModel.item(at: indexPath.row)
        cell.setup(with: item.title, font: item.font, textColor: item.textColor)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        handleSelection(forItem: viewModel.item(at: indexPath.row))
    }
}

// MARK: - Selection

extension SidebarViewController {
    
    fileprivate func handleSelection(forItem item: SidebarCellType) {
        switch item {
        case .settings: delegate?.didTapSettingsMenuCell(in: self)
        case .library: delegate?.didTapLibraryCell(in: self)
        case .benefits: delegate?.didTapBenefitsCell(in: self)
        case .about: delegate?.didTapAboutCell(in: self)
        case .privacy: delegate?.didTapPrivacyCell(in: self)
        default: return
        }
    }
}
