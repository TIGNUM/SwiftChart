//
//  Dequeable.swift
//  QOT
//
//  Created by Sam Wyndham on 27/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

/// Encapsulates the registration method of a cell.
enum DequeueRegistration {
    /// The view should register the cell using the provided nib.
    case nib(UINib)
    /// The view shoulc register the cell using it's class.
    case `class`
}

/// Encapsulates information to register and deque a `UITableViewCell` or `UICollectionViewCell`.
protocol Dequeueable: class {
    /// The `DequeueRegistration` of `self`
    static var registration: DequeueRegistration { get }
    /// The resuse identifier of `self
    static var reuseID: String { get }
}

extension Dequeueable {
    static var registration: DequeueRegistration {
        if Bundle.main.path(forResource: className, ofType: "nib") != nil { // Suprisingly .xib are still of type .nib!
            let nib = UINib(nibName: className, bundle: Bundle.main)
            return .nib(nib)
        } else {
            return .class
        }
    }

    static var reuseID: String {
        return className
    }

    private static var className: String {
        return String(describing: self)
    }
}

extension UITableView {
    /// Registers a `Dequeueable` for use in creating new cells.
    func registerDequeueable<T: UITableViewCell>(_ cellClass: T.Type) where T: Dequeueable {
        switch cellClass.registration {
        case .nib(let nib):
            register(nib, forCellReuseIdentifier: cellClass.reuseID)
        case .class:
            register(cellClass, forCellReuseIdentifier: cellClass.reuseID)
        }
    }

    /// Returns a reusable cell of type `T` at `indexPath` and adds it to the table view.
    func dequeueCell<T: UITableViewCell>(for indexPath: IndexPath) -> T where T: Dequeueable {
        let cell = dequeueReusableCell(withIdentifier: T.reuseID, for: indexPath)
        guard let cast = cell as? T else {
            fatalError("Failed to cast cell: \(cell) to type: \(String(describing: T.self)) at indexPath: \(indexPath)")
        }
        return cast
    }
}

extension UICollectionView {
    /// Registers a `Dequeueable` for use in creating new cells.
    func registerDequeueable<T: UICollectionViewCell>(_ cellClass: T.Type) where T: Dequeueable {
        switch cellClass.registration {
        case .nib(let nib):
            register(nib, forCellWithReuseIdentifier: cellClass.reuseID)
        case .class:
            register(cellClass, forCellWithReuseIdentifier: cellClass.reuseID)
        }
    }

    /// Returns a reusable cell of type `T` at `indexPath` and adds it to the collection view.
    func dequeueCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T where T: Dequeueable {
        let cell = dequeueReusableCell(withReuseIdentifier: T.reuseID, for: indexPath)
        guard let cast = cell as? T else {
            fatalError("Failed to cast cell: \(cell) to type: \(String(describing: T.self)) at indexPath: \(indexPath)")
        }
        return cast
    }
}
