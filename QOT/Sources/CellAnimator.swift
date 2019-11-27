//
//  CellAnimator.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 06.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

typealias CellAnimation = (UITableViewCell, IndexPath) -> Void

final class CellAnimator {

    // MARK: - Properties

    private var hasAnimatedAllCells = false
    private let animation: CellAnimation

    // MARK: - Init

    init(animation: @escaping CellAnimation) {
        self.animation = animation
    }

    // MARK: - Start animation

    func animate(cell: UITableViewCell, at indexPath: IndexPath, in tableView: UITableView) {
        guard !hasAnimatedAllCells else { return }
        animation(cell, indexPath)
        hasAnimatedAllCells = tableView.isLastVisibleCell(at: indexPath)
    }
}

// MARK: - Animation Types

extension CellAnimator {

    static func moveUpWithFade(rowHeight: CGFloat, duration: TimeInterval, delayFactor: Double) -> CellAnimation {
        return { cell, indexPath in
            cell.transform = CGAffineTransform(translationX: 0, y: rowHeight / 2)
            cell.alpha = 0
            UIView.animate(withDuration: duration,
                           delay: delayFactor * Double(indexPath.row),
                           options: [.curveEaseInOut],
                           animations: {
                            cell.transform = CGAffineTransform(translationX: 0, y: 0)
                            cell.alpha = 1
            })
        }
    }
}

// MARK: - UITableView helpers

fileprivate extension UITableView {
    func isLastVisibleCell(at indexPath: IndexPath) -> Bool {
        guard let lastIndexPath = indexPathsForVisibleRows?.last else { return false }
        return lastIndexPath == indexPath
    }
}
