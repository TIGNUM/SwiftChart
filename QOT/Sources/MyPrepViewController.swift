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
    
    let viewModel: MyPrepViewModel
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
                                          font: Font.DPText,
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
                                                                      .font: Font.H5SecondaryHeadline]
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: style, target: self, action: action)
        barButtonItem.setTitleTextAttributes(barButtonTextAttributes, for: .normal)
        barButtonItem.setTitleTextAttributes(barButtonTextAttributes, for: .selected)

        return barButtonItem
    }

    // MARK: - Init

    init(viewModel: MyPrepViewModel) {
        self.viewModel = viewModel

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
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tableView.setEditing(false, animated: true)
    }

    @available(iOS 11.0, *)
    override func viewLayoutMarginsDidChange() {
        super.viewLayoutMarginsDidChange()
        tableView.contentInset.top = view.safeMargins.top
        tableView.contentInset.bottom = view.safeMargins.bottom
        view.setFadeMask(at: .topAndBottom)
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
        view.addSubview(tableView)

        automaticallyAdjustsScrollViewInsets = false
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
            tableView.edgeAnchors == view.edgeAnchors
            tableView.contentInset.top = view.safeMargins.top + Layout.paddingTop
            tableView.contentInset.bottom = view.safeMargins.bottom
        } else {
            tableView.topAnchor == view.topAnchor + Layout.paddingTop
            tableView.bottomAnchor == view.bottomAnchor
            tableView.leadingAnchor == view.leadingAnchor
            tableView.trailingAnchor == view.trailingAnchor
        }

        view.setFadeMask(at: .topAndBottom)
    }

    func updateView() {
        emptyLabel.isHidden = viewModel.itemCount > 0
        tableView.reloadData()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension MyPrepViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel.item(at: indexPath.row)
        let cell: MyPrepTableViewCell = tableView.dequeueCell(for: indexPath)
        var count = ""
        if item.totalPreparationCount > 0 {
            count = String(format: "%02d/%02d", item.finishedPreparationCount, item.totalPreparationCount)
        }
        var footer = ""
        if let startDate = item.startDate, let timeToEvent = DateComponentsFormatter.timeIntervalToString(startDate.timeIntervalSinceNow, isShort: true) {
            footer = R.string.localized.prepareMyPrepTimeToEvent(timeToEvent)
        }

        cell.setup(with: item.header, text: item.text, footer: footer, count: count)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = viewModel.item(at: indexPath.row)
        delegate?.didTapMyPrepItem(with: item, viewController: self)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.itemCount
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 117
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            try? self.viewModel.deleteItem(at: indexPath.row)
        }
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
}
