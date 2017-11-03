//
//  SearchFieldViewController.swift
//  QOT
//
//  Created by Aamir Suhial Mir on 5/24/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Anchorage

final class SearchViewController: UIViewController {

    private let viewModel = SearchViewModel()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 55, bottom: 10, right: 0)

        return UICollectionView(
            layout: layout,
            delegate: self,
            dataSource: self,
            dequeables: SearchCollectionCell.self
        )
    }()

    private lazy var tableView: UITableView = {
        return UITableView(
            estimatedRowHeight: 85,
            delegate: self,
            dataSource: self,
            dequeables: SearchTableCell.self
        )
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpHierarchy()
        setupLayout()
    }
}

// MARK: - Private

private extension SearchViewController {

    func setUpHierarchy() {
        view.addSubview(collectionView)
        view.addSubview(tableView)
    }

    func setupLayout() {
        collectionView.topAnchor == view.topAnchor + 60
        collectionView.heightAnchor == 90
        collectionView.horizontalAnchors == view.horizontalAnchors

        tableView.leftAnchor == collectionView.leftAnchor + 53
        tableView.rightAnchor == collectionView.rightAnchor
        tableView.bottomAnchor == view.bottomAnchor + 26
        tableView.topAnchor == view.topAnchor + 100

        view.layoutIfNeeded()
    }
}

// MARK: Delegate and DataSource For Collection View

extension SearchViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.headerItems.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = viewModel.headerItems[indexPath.item]
        let cell: SearchCollectionCell = collectionView.dequeueCell(for: indexPath)
        cell.backgroundColor = .clear
        cell.setUp(title: item)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 80)
    }
}

// MARK: Delegate and DataSource For Table View

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel.data[indexPath.item]
        let cell: SearchTableCell = tableView.dequeueCell(for: indexPath)
        cell.backgroundColor = .clear
        cell.setUp(title: item.title, media: item.subtitle, duration: item.duration)
        return cell
    }
}
