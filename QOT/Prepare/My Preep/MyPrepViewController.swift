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
        tableView.registerDequeueable(MyPrepTableViewCell.self)
    }

    func closeView(gestureRecognizer: UITapGestureRecognizer) {
        delegate?.didTapClose(in: self)
    }
    
    func prepareAndSetTextAttributes(string: String, value: CGFloat) -> NSMutableAttributedString {
        let attrString = NSMutableAttributedString(string: string)
        attrString.addAttribute(NSKernAttributeName, value: value, range: NSRange(location: 0, length: string.characters.count))
        return attrString
    }
}

extension MyPrepViewController {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel.item(at: indexPath.row)
        let cell: MyPrepTableViewCell = tableView.dequeueCell(for: indexPath)

        var finishedCount: String = ""
        if item.finishedPreparationCount >= 9 {
            finishedCount = "\(item.finishedPreparationCount)"
        } else {
            finishedCount = "0\(item.finishedPreparationCount)"
        }
        cell.headerLabel.attributedText = prepareAndSetTextAttributes(string: item.header.uppercased(), value: 2)
        cell.mainTextLabel.attributedText = prepareAndSetTextAttributes(string: item.text.uppercased(), value: -0.8)
        cell.footerLabel.attributedText = prepareAndSetTextAttributes(string: item.footer.uppercased(), value: 2)
        cell.prepCount.attributedText = prepareAndSetTextAttributes(string: "\(finishedCount)/\(item.totalPreparationCount)", value: -0.8)

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
