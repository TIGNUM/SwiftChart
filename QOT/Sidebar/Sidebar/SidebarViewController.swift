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
    func didTapClose(in viewController: UIViewController, animated: Bool)
    func didTapSettingsCell(in viewController: SidebarViewController)
    func didTapLibraryCell(in viewController: SidebarViewController)
}

final class SidebarViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var navBarView: UIView!
    @IBOutlet private weak var leftNavBarButton: UIButton!
    @IBOutlet private weak var rightNavBarButton: UIButton!
    
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
        
        setupView()
    }
    
    private func setupView() {
        tableView?.delegate = self
        tableView?.dataSource = self
        view.backgroundColor = .black
        tableView?.backgroundColor = .clear
        navBarView?.backgroundColor = .clear
        leftNavBarButton?.setTitleColor(.lightGray, for: .normal)
        rightNavBarButton?.setImage(R.image.ic_close()?.withRenderingMode(.alwaysTemplate), for: .normal)
        rightNavBarButton?.tintColor = .lightGray
        tableView?.register(UINib(nibName: R.nib.sidebarTableViewCell.name, bundle: nil), forCellReuseIdentifier: cellIdentifier)
    }
}

// MARK: - Actions

extension SidebarViewController {
    
    @IBAction private func didTapCloseButton() {
        delegate?.didTapClose(in: self, animated: true)
    }
    
    @IBAction private func didTapQOTButton() {
        delegate?.didTapClose(in: self, animated: true)
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
            return UITableViewCell()
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
        case .settings: delegate?.didTapSettingsCell(in: self)
        case .library: delegate?.didTapLibraryCell(in: self)
        default: return
        }
    }
}
