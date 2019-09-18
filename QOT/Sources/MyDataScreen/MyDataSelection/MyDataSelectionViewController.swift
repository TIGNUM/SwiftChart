//
//  MyDataSelectionViewController.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 20/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

protocol MyDataSelectionViewControllerDelegate: class {
    func didChangeSelected(options: [MyDataSelectionModel.SelectionItem])
}

final class MyDataSelectionViewController: UIViewController, ScreenZLevel3 {

    // MARK: - Properties
    var interactor: MyDataSelectionInteractorInterface?
    var router: MyDataSelectionRouterInterface?

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    private var myDataSelectionModel: MyDataSelectionModel?
    private let skeletonManager = SkeletonManager()
    weak var delegate: MyDataSelectionViewControllerDelegate?

    // MARK: - Init
    init(configure: Configurator<MyDataSelectionViewController>) {
        super.init(nibName: nil, bundle: nil)
        configure(self)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let configurator = MyDataSelectionConfigurator.make()
        configurator(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        skeletonManager.addTitle(titleLabel)
        skeletonManager.addSubtitle(subtitleLabel)
        interactor?.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackPage()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let selectionItems = myDataSelectionModel?.myDataSelectionItems else { return }
        interactor?.saveMyDataSelections(selectionItems)
        delegate?.didChangeSelected(options: selectedSections())
    }

    // MARK: - Helpers

    func selectedSections() -> [MyDataSelectionModel.SelectionItem] {
        guard let selectionItems = myDataSelectionModel?.myDataSelectionItems else { return [] }
        return selectionItems.filter({ (item) -> Bool in
            return item.selected
        })
    }
}

// MARK: - UITableView Delegate and Datasource
extension MyDataSelectionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myDataSelectionModel?.myDataSelectionItems.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MyDataSelectionScreenTableViewCell = tableView.dequeueCell(for: indexPath)
        cell.configure(forSelectionItem: myDataSelectionModel?.myDataSelectionItems[indexPath.row])

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let currentSelectedState = myDataSelectionModel?.myDataSelectionItems[indexPath.row].selected ?? false
        if let cell = tableView.cellForRow(at: indexPath) as? MyDataSelectionScreenTableViewCell {
            cell.showSelected = !currentSelectedState
            myDataSelectionModel?.myDataSelectionItems[indexPath.row].selected = !currentSelectedState
        }
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.size.width, height: 80))
    }
}

// MARK: - Private
private extension MyDataSelectionViewController {
    func setupTableView() {
        tableView.registerDequeueable(MyDataSelectionScreenTableViewCell.self)
        tableView.separatorInset = .zero
        tableView.separatorColor = .sand30
    }
}

// MARK: - MyDataSelectionViewControllerInterface
extension MyDataSelectionViewController: MyDataSelectionViewControllerInterface {
    func setupView() {
        setupTableView()
        ThemeView.level3.apply(view)
        ThemeView.level3.apply(tableView)
    }

    func setup(for myDataSelectionSection: MyDataSelectionModel,
               myDataSelectionHeaderTitle: String,
               myDataSelectionHeaderSubtitle: String) {
        skeletonManager.hide()
        myDataSelectionModel = myDataSelectionSection
        ThemeText.myDataSectionHeaderTitle.apply(myDataSelectionHeaderTitle, to: titleLabel)
        ThemeText.myDataSectionHeaderSubTitle.apply(myDataSelectionHeaderSubtitle, to: subtitleLabel)
    }
}
