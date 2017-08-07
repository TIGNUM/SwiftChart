//
//  LibraryViewController.swift
//  QOT
//
//  Created by karmic on 30/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Anchorage

enum SectionType {
    case latestPost
    case categoryPost

    var itemWidth: CGFloat {
        switch self {
        case .latestPost: return CGFloat(220)
        case .categoryPost: return CGFloat(275)
        }
    }

    var imageBottomConstraint: CGFloat {
        switch self {
        case .latestPost: return CGFloat(58)
        case .categoryPost: return CGFloat(0)
        }
    }

    var labelLeftRightMarging: CGFloat {
        switch self {
        case .latestPost: return CGFloat(4)
        case .categoryPost: return CGFloat(8)
        }
    }

    var rowHeight: CGFloat {
        switch self {
        case .latestPost: return CGFloat(280)
        case .categoryPost: return CGFloat(300)
        }
    }
}

protocol LibraryViewControllerDelegate: class {

    func didTapLibraryItem(item: ContentCollection)
    func didTapClose(in viewController: LibraryViewController)
}

final class LibraryViewController: UIViewController {

    // MARK: - Properties

    fileprivate let viewModel: LibraryViewModel
    fileprivate var viewDidAppear = false
    fileprivate var scrollToFinish = false
    weak var delegate: LibraryViewControllerDelegate?

    fileprivate lazy var tableView: UITableView = {
        return UITableView(
            delegate: self,
            dataSource: self,
            dequeables: LibraryTableViewCell.self
        )
    }()

    fileprivate lazy var topBarView: ArticleItemTopTabBarView = {
        guard let view = Bundle.main.loadNibNamed("ArticleItemTopTabBarView", owner: self, options: [:])?[0] as? ArticleItemTopTabBarView else {
            preconditionFailure("Failed to load ArticleItemTopTabBarView from xib")
        }

        var title = ""
        if self.title != nil {
            title = self.title!
        }

        view.setup(title: title,
                   leftButtonIcon: R.image.ic_minimize(),
                   delegate: self)
        return view
    }()

    // MARK: - Init

    init(viewModel: LibraryViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setTableViewFooter()
        setupView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        viewDidAppear = true
    }
}

// MARK: - Private

private extension LibraryViewController {

    func setupView() {

        let backgroundImageView = UIImageView(image: R.image.backgroundSidebar())

        view.addSubview(backgroundImageView)
        view.addSubview(tableView)
        view.addSubview(topBarView)

        backgroundImageView.horizontalAnchors == view.horizontalAnchors
        backgroundImageView.verticalAnchors == view.verticalAnchors

        topBarView.backgroundColor = .clear
        topBarView.topAnchor == view.topAnchor
        topBarView.horizontalAnchors == view.horizontalAnchors
        topBarView.heightAnchor == Layout.TabBarView.height
        tableView.topAnchor == topBarView.bottomAnchor

        view.backgroundColor = .clear
        tableView.bottomAnchor == view.bottomAnchor
        tableView.horizontalAnchors == view.horizontalAnchors
    }

    func setTableViewFooter() {
        let nib = R.nib.libraryFooterView()
        guard let footerView = (nib.instantiate(withOwner: self, options: nil).first as? LibraryFooterView) else {
            return
        }

        footerView.backgroundColor = .clear
        tableView.tableFooterView = footerView
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension LibraryViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sectionCount
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let sectionType: SectionType = indexPath.section == 0 ? .latestPost : .categoryPost
        return sectionType.rowHeight
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let contentCollection = viewModel.contentCollection(at: indexPath)
        let cell: LibraryTableViewCell = tableView.dequeueCell(for: indexPath)
        let sectionType: SectionType = indexPath.section == 0 ? .latestPost : .categoryPost
        cell.setUp(title: viewModel.titleForSection(indexPath.section), contentCollection: contentCollection, sectionType: sectionType)
        cell.delegate = delegate

        return cell
    }
}

// MARK: - UIScrollViewDelegate

extension LibraryViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if viewDidAppear == true && scrollView.contentOffset.y >= (scrollView.contentSize.height + 100 - scrollView.frame.size.height) {
            scrollToFinish = true
        }
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollToFinish == true {
            dismiss(animated: false, completion: nil)
        }
    }
}

// MARK: - ArticleItemTopTabBarViewDelegate

extension LibraryViewController: ArticleItemTopTabBarViewDelegate {

    func didTapLeftButton() {
        self.delegate?.didTapClose(in: self)
    }
}
