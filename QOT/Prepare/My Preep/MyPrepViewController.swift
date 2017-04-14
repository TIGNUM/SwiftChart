//
//  MyPrepViewController.swift
//  QOT
//
//  Created by karmic on 30/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

protocol MyPrepViewControllerDelegate: class {
    func didTapClose(in viewController: MyPrepViewController)
    func didTapMyPrepItem(with myPrepItem: MyPrepItem, at index: Index, from view: UIView, in viewController: MyPrepViewController)
}

class MyPrepViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Properties
    @IBOutlet weak var tableView: UITableView!
    let viewModel: MyPrepViewModel
    weak var delegate: MyPrepViewControllerDelegate?

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

<<<<<<< HEAD
        tableView.registerDequeueable(MyPrepTableViewCell.self)
=======
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(closeView))
        view.addGestureRecognizer(tapGestureRecognizer)
        view.backgroundColor = .yellow
>>>>>>> 4a0a2cf8594ded6dd9c9900fcf7984e3a2aa9e90
    }

    func closeView(gestureRecognizer: UITapGestureRecognizer) {
        delegate?.didTapClose(in: self)
    }
    
    func prepareAndSetTextAttributes(string: String, label: UILabel, value: CGFloat) {
        let attrString = NSMutableAttributedString(string: string)
        attrString.addAttribute(NSKernAttributeName, value: value, range: NSRange(location: 0, length: string.characters.count))
        label.attributedText = attrString
    }

}
extension MyPrepViewController {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel.item(at: indexPath.row)
        let cell: MyPrepTableViewCell = tableView.dequeueCell(for: indexPath)

        cell.headerLabel.text = item.header
        cell.mainTextLabel.text = item.text
        cell.footerLabel.text = item.footer
        cell.prepCount.text = ("\(item.totalPreparationCount)/\(item.finishedPreparationCount))")

        return cell

    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.itemCount
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 117
    }

}
