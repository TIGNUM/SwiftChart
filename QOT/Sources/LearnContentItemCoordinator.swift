//
//  LearnContentItemCoordinator.swift
//  QOT
//
//  Created by tignum on 3/30/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import RealmSwift

final class LearnContentItemCoordinator: ParentCoordinator {

    private let services: Services
    private let eventTracker: EventTracker
    private let category: ContentCategory
    private var categoryTitle: String
    private var selectedContent: ContentCollection
    private let fullViewController: LearnContentItemViewController
    private let bulletViewController: LearnContentItemViewController
    private let audioViewController: LearnContentItemViewController
    private var viewModel: LearnContentItemViewModel
    private var presentationManager: ContentItemAnimator?
    private weak var topBarDelegate: NavigationItemDelegate?
    private let rootViewController: UIViewController
    private let headerView: LearnContentItemHeaderView
    private let presentOnStart: Bool
    private let guideItem: Guide.Item?
    var children: [Coordinator] = []
    var topTabBarController: UINavigationController!

    init(root: UIViewController,
         eventTracker: EventTracker,
         services: Services,
         content: ContentCollection,
         category: ContentCategory,
         presentationManager: ContentItemAnimator? = nil,
         topBarDelegate: NavigationItemDelegate? = nil,
         presentOnStart: Bool = true,
         guideItem: Guide.Item? = nil) {
        self.rootViewController = root
        self.eventTracker = eventTracker
        self.services = services
        self.category = category
        self.categoryTitle = category.title.capitalized
        self.presentationManager = presentationManager
        self.selectedContent = content
        self.topBarDelegate = topBarDelegate
        self.presentOnStart = presentOnStart
        self.guideItem = guideItem
        self.viewModel = LearnContentItemViewModel(
            services: services,
            eventTracker: eventTracker,
            contentCollection: selectedContent,
            categoryID: category.forcedRemoteID
        )
        headerView = LearnContentItemHeaderView.fromXib(contentTitle: selectedContent.title.capitalized,
                                                        categoryTitle: categoryTitle.capitalized)
        fullViewController = LearnContentItemViewController(viewModel: viewModel, tabType: .full)
        fullViewController.title = R.string.localized.learnContentItemTitleFull()
        bulletViewController = LearnContentItemViewController(viewModel: viewModel, tabType: .bullets)
        bulletViewController.title = R.string.localized.learnContentItemTitleBullets()
        audioViewController = LearnContentItemViewController(viewModel: viewModel, tabType: .audio)
        audioViewController.title = R.string.localized.learnContentItemTitleAudio()
        var pages = [LearnContentItemViewController]()
        if content.hasFullItems == true {
            pages.append(fullViewController)
        }
        if content.hasBulletItems == true {
            pages.append(bulletViewController)
        }
        if content.hasAudioItems == true {
            pages.append(audioViewController)
        }
        let leftButton = UIBarButtonItem(withImage: R.image.ic_close()?.tintedImage(color: .gray).withRenderingMode(.alwaysOriginal))
        topTabBarController = UINavigationController(withPages: pages,
                                                     navigationItem: NavigationItem(),
                                                     headerView: headerView,
                                                     topBarDelegate: topBarDelegate ?? self,
                                                     pageDelegate: self,
                                                     backgroundColor: .nightModeBackground,
                                                     backgroundImage: nil,
                                                     leftButton: leftButton,
                                                     navigationItemStyle: Date().isNight ? .dark : .light)
        fullViewController.delegate = self
        bulletViewController.delegate = self
        audioViewController.delegate = self
        topTabBarController.navigationBar.barTintColor = .nightModeBackground
        topTabBarController.navigationBar.shadowImage = UIImage()
    }

    // FIXME: Add page tracking
    func start() {
        if rootViewController is UIViewControllerTransitioningDelegate {
            topTabBarController.modalPresentationStyle = .fullScreen  // Custom animations doesn't work when this value is set to .custom

            // If rootVC has a custom defined transition that one will be used
            // We have a custom transition from PrepareContent (when pressing readMore button)
            guard let transitionDelegate = rootViewController as? UIViewControllerTransitioningDelegate else { return }
            topTabBarController.transitioningDelegate = transitionDelegate
        } else if let presentationManager = presentationManager {
            topTabBarController.transitioningDelegate = presentationManager
        } else {
            topTabBarController.modalPresentationStyle = .custom
        }
        if presentOnStart {
            rootViewController.present(topTabBarController, animated: true)
        }

        guard
            let pageViewController = topTabBarController.viewControllers.first as? PageViewController,
            let navItem = pageViewController.navigationItem as? NavigationItem,
            guideItem != nil,
            selectedContent.hasBulletItems == true else { return }
        let bulletIndex = 1
        navItem.setIndicatorToButtonIndex(bulletIndex)
        pageViewController.setPageIndex(bulletIndex, animated: true)
    }
}

// MARK: - TopNavigationBarDelegate

extension LearnContentItemCoordinator: NavigationItemDelegate {

    func navigationItem(_ navigationItem: NavigationItem, leftButtonPressed button: UIBarButtonItem) {
        topTabBarController.dismiss(animated: true, completion: nil)
        if AppCoordinator.currentStatusBarStyle != nil {
            AppCoordinator.updateStatusBarStyleIfNeeded()
        } else {
            UIApplication.shared.setStatusBarStyle(.lightContent)
        }
    }

    func navigationItem(_ navigationItem: NavigationItem, middleButtonPressedAtIndex index: Int, ofTotal total: Int) {
        guard let pageViewController = topTabBarController.viewControllers.first as? PageViewController else { return }
        pageViewController.setPageIndex(index, animated: true)
        if let tableView = (pageViewController.viewControllers?.first as? LearnContentItemViewController)?.itemTableView {
            pageViewController.pageDidScroll(in: tableView)
        }
    }

    func navigationItem(_ navigationItem: NavigationItem, rightButtonPressed button: UIBarButtonItem) {
        log("did select book mark")
    }
}

// MARK: - LearnContentItemViewControllerDelegate

extension LearnContentItemCoordinator: LearnContentItemViewControllerDelegate {

    func didTapFinish(from view: UIView) {
        log("didTapFinish")
    }

    func didTapShare(in viewController: LearnContentItemViewController) {
        log("didTapShare")
    }

    func didSelectReadMoreContentCollection(with collectionID: Int, in viewController: LearnContentItemViewController) {
        guard let contentCollection = services.contentService.contentCollection(id: collectionID) else {
            return
        }

        selectedContent = contentCollection
        viewModel = LearnContentItemViewModel(
            services: services,
            eventTracker: eventTracker,
            contentCollection: selectedContent,
            categoryID: category.forcedRemoteID
        )

        // FIXME: We need a more sensible way of getting the subtitle.
        let subtitle = contentCollection.contentCategories.first?.title.uppercased() ?? ""
        headerView.setupView(title: contentCollection.title.uppercased(), subtitle: subtitle)
        fullViewController.reloadData(viewModel: viewModel)
        bulletViewController.reloadData(viewModel: viewModel)
        audioViewController.reloadData(viewModel: viewModel)
    }

    func didTapVideo(with video: ContentItem, from view: UIView, in viewController: LearnContentItemViewController) {
        log("didTapVideo")
    }

    func didTapArticle(with article: ContentItem, from view: UIView, in viewController: LearnContentItemViewController) {
        log("didTapArticle")
    }

    func didTapPDF(withURL url: URL, in viewController: LearnContentItemViewController, title: String, itemID: Int) {
        let storyboard = UIStoryboard(name: "PDFReaderViewController", bundle: nil)
        guard let navigationController = storyboard.instantiateInitialViewController() as? UINavigationController else {
            return
        }
        guard let readerViewController = navigationController.viewControllers.first as? PDFReaderViewController else {
            return
        }
        let pdfReaderConfigurator = PDFReaderConfigurator.make(contentItemID: itemID, title: title, url: url)
        pdfReaderConfigurator(readerViewController)
        viewController.present(navigationController, animated: true, completion: nil)
    }
}

// MARK: - PageViewControllerDelegate

extension LearnContentItemCoordinator: PageViewControllerDelegate {

    func pageViewController(_ controller: UIPageViewController, didSelectPageIndex index: Int) {
        guard let navItem = controller.navigationItem as? NavigationItem else { return }
        navItem.setIndicatorToButtonIndex(index)
    }
}
