//
//  SelectWeeklyChoicesViewController.swift
//  QOT
//
//  Created by Lee Arromba on 10/07/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import MBProgressHUD

protocol SelectWeeklyChoicesViewControllerDelegate: class {

    func dismiss(viewController: SelectWeeklyChoicesViewController)

    func didTapRow(_ viewController: SelectWeeklyChoicesViewController, contentCollection: ContentCollection, contentCategory: ContentCategory)
}

final class SelectWeeklyChoicesViewController: UIViewController {

    private struct CellReuseIdentifiers {
        static let CollapsableCell = "CollapsableCell"
        static let CollapsableContentCell = "CollapsableContentCell"
    }

    // MARK: - Properties
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var backgroundBlurView: UIVisualEffectView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var closeButton: UIBarButtonItem!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var tableHeaderView: UIView!
    @IBOutlet weak var tableHeaderViewLabel: UILabel!
    private var backgroundImage: UIImage?
    let viewModel: SelectWeeklyChoicesDataModel
    weak var delegate: SelectWeeklyChoicesViewControllerDelegate?

    // MARK: - Init
    
    init(delegate: SelectWeeklyChoicesViewControllerDelegate, viewModel: SelectWeeklyChoicesDataModel, backgroundImage: UIImage?) {
        self.delegate = delegate
        self.viewModel = viewModel
        self.backgroundImage = backgroundImage

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    // MARK: - private
    
    private func setupView() {
        tableView.tableHeaderView = tableHeaderView
        var nib = UINib(nibName: CollapsableCell.nibName, bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: CellReuseIdentifiers.CollapsableCell)
        nib = UINib(nibName: CollapsableContentCell.nibName, bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: CellReuseIdentifiers.CollapsableContentCell)
        tableView.layoutMargins = .zero
        tableView.separatorInset = .zero
        tableView.tableFooterView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 0.0, height: 20.0))
        backgroundImageView.image = backgroundImage
        backgroundBlurView.alpha = 0.85 // changing blur view alpha is not recommended, but it looks better...
        setSelected(viewModel.numOfItemsSelected)
        navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white, .font: Font.H6NavigationTitle]
        let dummyImage = UIImage()
        navigationBar.setBackgroundImage(dummyImage, for: .default)
        navigationBar.shadowImage = dummyImage
        navigationBar.isTranslucent = true
        
        tableHeaderViewLabel.attributedText = NSMutableAttributedString(
            string: R.string.localized.meSectorMyWhySelectWeeklyChoicesHeader("\(viewModel.maxSelectionCount)"),
            letterSpacing: 2,
            font: UIFont.bentonRegularFont(ofSize: 15.0),
            lineSpacing: 12.0,
            textColor: UIColor.white,
            alignment: .center)
    }
    
    private func setSelected(_ selected: Int) {
        let maxSelectionCount = viewModel.maxSelectionCount
        navigationBar.topItem?.title = R.string.localized.meSectorMyWhySelectWeeklyChoicesNavigation("\(maxSelectionCount)", "\(selected)", "\(viewModel.maxSelectionCount)").uppercased()
        doneButton.isEnabled = selected == maxSelectionCount
    }
    
    private func showMaxSelectionCountAlert() {
        let alert = UIAlertController(
            title: R.string.localized.meSectorMyWhySelectWeeklyChoicesMaxChoiceAlertTitle(),
            message: R.string.localized.meSectorMyWhySelectWeeklyChoicesMaxChoiceAlertMessage(),
            preferredStyle: .alert)
        alert.addAction(
            UIAlertAction(
                title: R.string.localized.meSectorMyWhySelectWeeklyChoicesMaxChoiceAlertButton(),
                style: .default,
                handler: nil)
        )
        present(alert, animated: true, completion: nil)
    }

    // MARK: - actions
    
    @IBAction private func closePressed(_ sender: UIBarButtonItem) {
        delegate?.dismiss(viewController: self)
    }
    
    @IBAction private func donePressed(_ sender: UIBarButtonItem) {
        _ = MBProgressHUD.showAdded(to: view, animated: true)
        DispatchQueue.main.async { [unowned self] in
            self.viewModel.createUsersWeeklyChoices()
        }
        delegate?.dismiss(viewController: self)
    }
}

// MARK: - UITableViewDelegate

extension SelectWeeklyChoicesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.rowHeight(forIndexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if viewModel.isParentNode(atIndexPath: indexPath) {
            let node = viewModel.node(forSection: indexPath.section)
            viewModel.setIsOpen(!node.isOpen, forNodeAtSection: indexPath.section)
            tableView.reloadDataWithAnimation()
        } else {
            guard
                let contentCollection = viewModel.contentCollection(forIndexPath: indexPath),
                let contentCategory = viewModel.contentCategory(forIndexPath: indexPath) else {
                    return
            }

            delegate?.didTapRow(self, contentCollection: contentCollection, contentCategory: contentCategory)
        }
    }
}

// MARK: - UITableViewDataSource

extension SelectWeeklyChoicesViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(inSection: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if viewModel.isParentNode(atIndexPath: indexPath) {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellReuseIdentifiers.CollapsableCell) as? CollapsableCell else {
                return UITableViewCell() // shouldnt happen...
            }
            let node = viewModel.node(forSection: indexPath.section)
            cell.setTitleText(node.title)
            cell.delegate = self
            cell.indexPath = indexPath
            cell.isOpen = node.isOpen
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellReuseIdentifiers.CollapsableContentCell) as? CollapsableContentCell else {
                return UITableViewCell() // shouldnt happen...
            }
            let item = viewModel.item(forIndexPath: indexPath)
            cell.setTitleText(item.title)
            cell.delegate = self
            cell.indexPath = indexPath
            cell.isChecked = item.selected
            return cell
        }
    }
}

// MARK: - CollapsableCellDelegate

extension SelectWeeklyChoicesViewController: CollapsableCellDelegate {
    func collapsableCell(_ cell: CollapsableCell, didPressCollapseButtonForIndexPath indexPath: IndexPath) {
        guard let isOpen = cell.isOpen else {
            return
        }
        viewModel.setIsOpen(!isOpen, forNodeAtSection: indexPath.section)
        tableView.reloadDataWithAnimation()
    }
}

// MARK: - CollapsableContentCellDelegate

extension SelectWeeklyChoicesViewController: CollapsableContentCellDelegate {
    func collapsableContentCell(_ cell: CollapsableContentCell, didPressCheckButtonForIndexPath indexPath: IndexPath) {
        var item = viewModel.item(forIndexPath: indexPath)
        if !item.selected {
            guard viewModel.numOfItemsSelected < viewModel.maxSelectionCount else {
                showMaxSelectionCountAlert()
                return
            }
        }
        item.selected = !item.selected
        viewModel.replace(item, atIndexPath: indexPath)
        setSelected(viewModel.numOfItemsSelected)
        tableView.reloadDataWithAnimation()
    }
}
