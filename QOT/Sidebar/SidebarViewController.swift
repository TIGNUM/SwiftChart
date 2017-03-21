//
//  SidebarViewController.swift
//  QOT
//
//  Created by karmic on 20/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit

final class SidebarViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var tableView: UITableView?
    @IBOutlet private weak var navBarView: UIView?
    @IBOutlet private weak var leftNavBarButton: UIButton?
    @IBOutlet private weak var rightNavBarButton: UIButton?
    
    // MARK: - Properties
    
    let viewModel: SidebarViewModel
    
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
        tableView?.backgroundColor = .clear
        navBarView?.backgroundColor = .clear
        leftNavBarButton?.setTitleColor(.lightGray, for: .normal)
        rightNavBarButton?.setImage(R.image.ic_close()?.withRenderingMode(.alwaysTemplate), for: .normal)
        rightNavBarButton?.tintColor = .lightGray
    }
}
