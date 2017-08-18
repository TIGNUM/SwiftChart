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

    var rowHeight: CGFloat {
        switch self {
        case .latestPost: return CGFloat(412)
        case .categoryPost: return CGFloat(432)
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
    weak var delegate: LibraryViewControllerDelegate?

    fileprivate lazy var tableView: UITableView = {
        return UITableView(
            delegate: self,
            dataSource: self,
            dequeables:
                LibraryTableViewCell.self,
                LibraryTableViewCategoryCell.self
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

        setupView()
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
        let sectionType: SectionType = indexPath.section == 0 ? .latestPost : .categoryPost

        if sectionType == .latestPost {
            let cell: LibraryTableViewCell = tableView.dequeueCell(for: indexPath)
            let contentCollection = viewModel.contentCollection(at: indexPath)
            cell.setUp(title: viewModel.titleForSection(indexPath.section), contentCollection: contentCollection, sectionType: sectionType)
            cell.delegate = delegate
            cell.backgroundColor = .clear

            return cell
        }

        let cell: LibraryTableViewCategoryCell = tableView.dequeueCell(for: indexPath)
        let contentCollection = viewModel.contentCollection(at: indexPath)
        cell.setUp(title: viewModel.titleForSection(indexPath.section), contentCollection: contentCollection, sectionType: sectionType)
        cell.delegate = delegate
        cell.backgroundColor = .clear

        return cell
    }
}

// MARK: - ArticleItemTopTabBarViewDelegate

extension LibraryViewController: ArticleItemTopTabBarViewDelegate {

    func didTapLeftButton() {
        self.delegate?.didTapClose(in: self)
    }
}
