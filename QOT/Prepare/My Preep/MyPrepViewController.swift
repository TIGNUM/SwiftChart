//
//  MyPrepViewController.swift
//  QOT
//
//  Created by karmic on 30/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

protocol MyPrepViewControllerDelegate: class {
    func didTapMyPrepItem(with myPrepItem: MyPrepItem, at index: Index, from view: UIView, in viewController: MyPrepViewController)
}

class MyPrepViewController: UIViewController {

    // MARK: - Properties

    @IBOutlet weak var tableView: UITableView!
    let viewModel: MyPrepViewModel
    weak var delegate: MyPrepViewControllerDelegate?
    weak var topTabBarScrollViewDelegate: TopTabBarScrollViewDelegate?

    // MARK: - Life Cycle

    init(viewModel: MyPrepViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .clear
        tableView.backgroundColor = .clear
        tableView.registerDequeueable(MyPrepTableViewCell.self)
        tableView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 64, right: 0)
    }
    
    func prepareAndSetTextAttributes(string: String, value: CGFloat) -> NSMutableAttributedString {
        let attrString = NSMutableAttributedString(string: string)
        attrString.addAttribute(NSKernAttributeName, value: value, range: NSRange(location: 0, length: string.utf16.count))

        return attrString
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension MyPrepViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel.item(at: indexPath.row)
        let cell: MyPrepTableViewCell = tableView.dequeueCell(for: indexPath)
        let finishedCount: String = String(format: "%02d", item.finishedPreparationCount)
        cell.headerLabel.attributedText = prepareAndSetTextAttributes(string: item.header.uppercased(), value: 2)
        cell.mainTextLabel.attributedText = prepareAndSetTextAttributes(string: item.text.uppercased(), value: -0.8)
        cell.footerLabel.attributedText = prepareAndSetTextAttributes(string: item.footer.uppercased(), value: 2)
        cell.prepCount.attributedText = prepareAndSetTextAttributes(string: "\(finishedCount)/\(item.totalPreparationCount)", value: -0.8)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = viewModel.item(at: indexPath.row)
        delegate?.didTapMyPrepItem(with: item, at: indexPath.row, from: view, in: self)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.itemCount
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 117
    }
}

// MARK: - UIScrollViewDelegate

extension MyPrepViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.didScrollUnderTopTabBar(delegate: topTabBarScrollViewDelegate)
    }
}
