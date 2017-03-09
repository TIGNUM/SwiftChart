//
//  LearnContentListViewController.swift
//  QOT
//
//  Created by Sam Wyndham on 09/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

/// The delegate of a `LearnContentListViewController`.
protocol LearnContentListViewControllerDelegate: class {
    /// Notifies `self` that the content was selected at `index` in `viewController`.
    func didSelectContent(at index: Index, in viewController: LearnContentListViewController)
    /// Notifies `self` that the back button was tapped in `viewController`.
    func didTapBack(in: LearnContentListViewController)
}

// FIXME: This is a dummy implementation o fLearnContentListViewController.

/// Displays a collection of items of learn content.
final class LearnContentListViewController: UITableViewController {
    let viewModel: LearnContentListViewModel
    
    weak var delegate: LearnContentListViewControllerDelegate?
    
    init(viewModel: LearnContentListViewModel) {
        self.viewModel = viewModel
        
        super.init(style: .plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.itemCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseID = "cell"
        let content = viewModel.item(at: indexPath.row)
        
        let cell: UITableViewCell
        if let existing = tableView.dequeueReusableCell(withIdentifier: reuseID) {
            cell = existing
        } else {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: reuseID)
        }
        
        cell.textLabel?.text = content.title
        cell.detailTextLabel?.text = content.viewed ? "viewed" : "\(content.minutesRequired) min"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectContent(at: indexPath.row, in: self)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < -150 {
            delegate?.didTapBack(in: self)
        }
    }
}
