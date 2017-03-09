//
//  LearnCategoriesViewController.swift
//  QOT
//
//  Created by Sam Wyndham on 08/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

/// The delegate of a `LearnCategoryListViewController`.
protocol LearnCategoryListViewControllerDelegate: class {
    /// Notifies `self` that the category was selected at `index` in `viewController`.
    func didSelectCategory(at index: Index, in viewController: LearnCategoryListViewController)
}

// FIXME: This is a dummy implementation of LearnCategoryListViewController.

/// Displays a collection of learn categories of learn content.
final class LearnCategoryListViewController: UITableViewController {
    let viewModel: LearnCategoryListViewModel
    
    weak var delegate: LearnCategoryListViewControllerDelegate?
    
    init(viewModel: LearnCategoryListViewModel) {
        self.viewModel = viewModel
        
        super.init(style: .plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.categoryCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseID = "cell"
        let category = viewModel.category(at: indexPath.row)
        
        let cell: UITableViewCell
        if let existing = tableView.dequeueReusableCell(withIdentifier: reuseID) {
            cell = existing
        } else {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: reuseID)
        }

        cell.textLabel?.text = category.title
        cell.detailTextLabel?.text = "\(category.viewedCount)/\(category.itemCount)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectCategory(at: indexPath.row, in: self)
    }
}
