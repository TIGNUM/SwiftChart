//
//  MyPrepViewController.swift
//  QOT
//
//  Created by karmic on 30/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Anchorage
import Bond
import ReactiveKit

protocol MyPrepViewControllerDelegate: class {
    func didTapMyPrepItem(with myPrepItem: MyPrepViewModel.Item, viewController: MyPrepViewController)
}

final class MyPrepViewController: UIViewController, FullScreenLoadable, PageViewControllerNotSwipeable {

    // MARK: - Properties

    static var page: PageName = .myPreparations
    private let syncManager: SyncManager
    let viewModel: MyPrepViewModel
    let fadeContainerView = FadeContainerView()
    weak var delegate: MyPrepViewControllerDelegate?
    var loadingView: BlurLoadingView?
    var isLoading: Bool = false {
        didSet {
            showLoading(isLoading, text: R.string.localized.meMyPrepLoading())
        }
    }

    private let disposeBag = DisposeBag()
    private lazy var tableView: UITableView = {
        return UITableView(delegate: self,
                           dataSource: self,
                           dequeables: MyPrepTableViewCell.self)
    }()
    private lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textColor = .white40
        label.numberOfLines = 0
        label.setAttrText(text: R.string.localized.prepareMyPrepNoSavePreparations(),
                                          font: .DPText,
                                          alignment: .center,
                                          lineSpacing: 7,
                                          characterSpacing: 1)
        self.view.addSubview(label)
        label.horizontalAnchors == self.view.horizontalAnchors
        label.verticalAnchors == self.view.verticalAnchors

        return label
    }()
    private func barButtonItem(_ style: UIBarButtonSystemItem, action: Selector?) -> UIBarButtonItem {
        let barButtonTextAttributes: [NSAttributedStringKey: Any] = [.foregroundColor: UIColor.whiteLight40,
                                                                     .font: UIFont.H5SecondaryHeadline]
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: style, target: self, action: action)
        barButtonItem.setTitleTextAttributes(barButtonTextAttributes, for: .normal)
        barButtonItem.setTitleTextAttributes(barButtonTextAttributes, for: .selected)
        return barButtonItem
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return ColorMode.dark.statusBarStyle
    }

    // MARK: - Init

    init(viewModel: MyPrepViewModel, syncManager: SyncManager) {
        self.viewModel = viewModel
        self.syncManager = syncManager
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        observeViewModel()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateReadyState()
        tableView.setContentOffset(.zero, animated: false)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tableView.setEditing(false, animated: true)
    }
}

// MARK: - Private

private extension MyPrepViewController {

    func updateReadyState() {
        isLoading = !viewModel.isReady()
    }

    func observeViewModel() {
        viewModel.updates.observeNext { [unowned self] (change: MyPrepViewModel.CollectionUpdate) in
            switch change {
            case .reload,
                 .update: self.updateView()
            default: return
            }
        }.dispose(in: disposeBag)

        viewModel.itemCountUpdate.observeNext {[unowned self] itemCount in
            self.updateView()
        }.dispose(in: disposeBag)
    }

    func setupView() {
        view.backgroundColor = .clear
        view.addSubview(fadeContainerView)
        fadeContainerView.edgeAnchors == view.edgeAnchors
        fadeContainerView.addSubview(tableView)
        automaticallyAdjustsScrollViewInsets = false
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        tableView.topAnchor == view.topAnchor
        tableView.bottomAnchor == view.bottomAnchor
        tableView.leadingAnchor == view.leadingAnchor
        tableView.trailingAnchor == view.trailingAnchor
        tableView.contentInset.top = 0
        tableView.contentInset.bottom = safeAreaInsets.bottom + Layout.padding_64
    }

    func updateView() {
        emptyLabel.isHidden = viewModel.itemCount > 0
        updateReadyState()
        tableView.reloadData()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension MyPrepViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel.item(at: indexPath)
        let cell: MyPrepTableViewCell = tableView.dequeueCell(for: indexPath)
        var count = ""
        if item.totalPreparationCount > 0 {
            count = String(format: "%02d/%02d", item.finishedPreparationCount, item.totalPreparationCount)
        }
        var footer = ""
        var lineColor = UIColor.white
        if let startDate = item.startDate {
            footer = startDate.eventStringDate
            if item.startDate?.timeIntervalSinceNow.sign == .minus {
                lineColor = .gray
            }
        }

        cell.setup(with: item.header, text: item.text, footer: footer, count: count, lineColor: lineColor)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = viewModel.item(at: indexPath)
        delegate?.didTapMyPrepItem(with: item, viewController: self)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.itemCount(at: section)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 117
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            try? self.viewModel.deleteItem(at: indexPath)
        }
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }

    // MARK: Section Headers

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.viewModel.itemTypeString(at: section)
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let headerLabel = (view as? UITableViewHeaderFooterView)?.textLabel else { return }
        if let headerTitle = headerLabel.text {
            headerLabel.attributedText = Style.headlineSmall(headerTitle.uppercased(), .white).attributedString(lineSpacing: 0)
            (view as? UITableViewHeaderFooterView)?.backgroundView?.backgroundColor = .darkAzure
            (view as? UITableViewHeaderFooterView)?.contentView.backgroundColor = .clear
        }
    }
}
