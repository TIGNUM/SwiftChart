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
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(closeView))
        view.addGestureRecognizer(tapGestureRecognizer)
        view.backgroundColor = .black
    }
    
    func closeView(gestureRecognizer: UITapGestureRecognizer) {
        delegate?.didTapClose(in: self)
    }
}

extension LibraryViewController: UITableViewDelegate, UICollectionViewDelegate {
    
    // table View Delegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sectionCount
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModel.numberOfItemsInSection(in: section)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    // Collection View Delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension LibraryViewController: UITableViewDataSource, UICollectionViewDataSource {
    
    // table view ViewDataSource
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel.styleForSection(indexPath.item)
        
        switch item {
        case .lastPost:
            let cell: LatestPostCell = tableView.dequeueCell(for: indexPath)
            
            return cell
        case .category:
            let cell: CategoryPostCell = tableView.dequeueCell(for: indexPath)
            return cell
        }
    }
    
    // Collection ViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: LearnContentCell = collectionView.dequeueCell(for: indexPath)
        
        return cell
    }
    
}
