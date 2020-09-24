//
//  MyQotMainPresenter.swift
//  QOT
//
//  Created by Anais Plancoulaine on 11.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import DifferenceKit
import qot_dal

final class MyQotMainPresenter {

    // MARK: - Properties
    private weak var viewController: MyQotMainViewControllerInterface?

    // MARK: - Init
    init(viewController: MyQotMainViewControllerInterface?) {
        self.viewController = viewController
    }
}

// MARK: - KnowingInterface
extension MyQotMainPresenter: MyQotMainPresenterInterface {
    func setupView() {
        viewController?.setupView()
    }

    func reload() {
        log("viewController?.reload()", level: .debug)
        viewController?.reload()
    }

    func presentItemsWith(identifiers: [String], maxCount: Int) {
        // this process supports only adding items or deleting items.
        // Doesn't support add some items and deleting some items at the same time.
        log("identifiers: ♻️♻️♻️ \(identifiers)", level: .debug)
        var handledPrefixes = [String]()
        var indexPathsToRemove = [IndexPath]()
        var indexPathsToAdd = [IndexPath]()
        var indexPathsToUpdate = [IndexPath]()
        var newIndexPathsForUpdatedItems = [IndexPath]()
        for index in (0...maxCount) {
            let indexPath = IndexPath(item: index, section: 2)
            if let cell = viewController?.collectionViewCell(at: indexPath),
                let reuseIdentifier = cell.reuseIdentifier,
                let prefix = reuseIdentifier.components(separatedBy: "_").first {
                log("prefix: ♻️♻️♻️ \(prefix)", level: .debug)
                if identifiers.contains(prefix) {
                    indexPathsToUpdate.append(indexPath)
                    handledPrefixes.append(prefix)
                    newIndexPathsForUpdatedItems.append(IndexPath(item: identifiers.firstIndex(of: prefix) ?? 0, section: 2))
                } else {
                    indexPathsToRemove.append(indexPath)
                }
            }
        }
        for (index, identifier) in identifiers.enumerated() {
            if !handledPrefixes.contains(obj: identifier) {
                indexPathsToAdd.append(IndexPath(item: index, section: 2))
            }
        }
        log("indexPathsToRemove: ♻️♻️♻️ \(indexPathsToRemove)", level: .debug)
        log("indexPathsToUpdate: ♻️♻️♻️ \(indexPathsToUpdate)", level: .debug)
        log("newIndexPathsForUpdatedItems: ♻️♻️♻️ \(newIndexPathsForUpdatedItems)", level: .debug)
        log("indexPathsToAdd: ♻️♻️♻️ \(indexPathsToAdd)", level: .debug)
        viewController?.updateViewCells(deleteIndexPaths: indexPathsToRemove,
                                        updateIndexPaths: indexPathsToUpdate,
                                        newIndexPathsForUpdatedItems: newIndexPathsForUpdatedItems,
                                        insertIndexPaths: indexPathsToAdd)
    }
}
