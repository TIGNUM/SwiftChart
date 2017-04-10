//
//  LibraryViewController.swift
//  QOT
//
//  Created by karmic on 30/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

protocol LibraryViewControllerDelegate: class {
    func didTapClose(in viewController: LibraryViewController)
    func didTapMedia(with mediaItem: LibraryMediaItem, from view: UIView, in viewController: UIViewController)
}

final class LibraryViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var tableView: UITableView!
    let viewModel: LibraryViewModel
    weak var delegate: LibraryViewControllerDelegate?
    
    // MARK: - Life Cycle
    
    init(viewModel: LibraryViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerDequeueable(LatestPostCell.self)
        tableView.registerDequeueable(CategoryPostCell.self)
        //let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(closeView))
        //view.addGestureRecognizer(tapGestureRecognizer)
        view.backgroundColor = .black
        tableView.estimatedRowHeight = 20
        tableView.rowHeight = UITableViewAutomaticDimension
    }
}

extension LibraryViewController: UITableViewDelegate, UICollectionViewDelegate {
    
    // table View Delegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModel.sectionCount
    }
    
    // Collection View Delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension LibraryViewController: UITableViewDataSource {
    
    // table DataSource
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = viewModel.styleForSection(indexPath.item)
        tableView.rowHeight = UITableViewAutomaticDimension
        switch section {
            
        case .lastPost:
            let cell: LatestPostCell = tableView.dequeueCell(for: indexPath)
            cell.setUp(title: "\(viewModel.titleForSection(indexPath.item))", sectionCount: viewModel.numberOfItemsInSection(in: indexPath.section))
            return cell
            
        case .category:
            let cell: CategoryPostCell = tableView.dequeueCell(for: indexPath)
            cell.setUp(title: "\(viewModel.titleForSection(indexPath.item))", sectionCount: viewModel.sectionCount)
            return cell
        }
    }
}
