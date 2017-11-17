//
//  LearnContentItemCoordinator.swift
//  QOT
//
//  Created by tignum on 3/30/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import RealmSwift
import SafariServices

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
    private weak var topBarDelegate: TopNavigationBarDelegate?
    private let rootViewController: UIViewController
    private let headerView: LearnContentItemHeaderView
    private let presentOnStart: Bool
    var children: [Coordinator] = []
    var topTabBarController: UINavigationController!
    
    init(root: UIViewController, eventTracker: EventTracker, services: Services, content: ContentCollection, category: ContentCategory, presentationManager: ContentItemAnimator? = nil, topBarDelegate: TopNavigationBarDelegate? = nil, presentOnStart: Bool = true) {
        self.rootViewController = root
        self.eventTracker = eventTracker
        self.services = services
        self.category = category
        self.categoryTitle = category.title.capitalized
        self.presentationManager = presentationManager
        self.selectedContent = content
        self.topBarDelegate = topBarDelegate
        self.presentOnStart = presentOnStart
        self.viewModel = LearnContentItemViewModel(
            services: services,
            eventTracker: eventTracker,
            contentCollection: selectedContent,
            categoryID: category.forcedRemoteID
        )

        headerView = LearnContentItemHeaderView.fromXib(contentTitle: selectedContent.title.capitalized, categoryTitle: categoryTitle.capitalized)
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

        let leftButton = UIBarButtonItem(withImage: R.image.ic_minimize_dark()?.withRenderingMode(.alwaysOriginal))
        topTabBarController = UINavigationController(withPages: pages,
                                                     headerView: headerView,
                                                     topBarDelegate: topBarDelegate ?? self,
                                                     pageDelegate: self,
                                                     backgroundColor: .white,
                                                     backgroundImage: nil,
                                                     titleSelectedColor: .black,
                                                     titleNormalColor: .black40,
                                                     leftButton: leftButton)
        if let navigationBar = topTabBarController.navigationBar as? TopNavigationBar {
            navigationBar.setStyle(selectedColor: .black, normalColor: .black40, backgroundColor: .white)
            leftButton.tintColor = .black40

            if pages.count <= 1 {
                navigationBar.setMiddleButtons([])
                navigationBar.topItem?.titleView = nil
            }
        }

        fullViewController.delegate = self
        bulletViewController.delegate = self
        audioViewController.delegate = self
    }

    func start() {
        if rootViewController is UIViewControllerTransitioningDelegate {
            topTabBarController.modalPresentationStyle = .fullScreen  // Custom animations doesn't work when this value is set to .custom

            // If rootVC has a custom defined transition that one will be used
            // We have a custom transition from PrepareContent (when pressing readMore button)
            guard let transitionDelegate = rootViewController as? UIViewControllerTransitioningDelegate else {
                return
            }

            topTabBarController.transitioningDelegate = transitionDelegate
        } else if let presentationManager = presentationManager {
            topTabBarController.transitioningDelegate = presentationManager
        } else {
            topTabBarController.modalPresentationStyle = .custom
        }

        if presentOnStart {
            rootViewController.present(topTabBarController, animated: true)
        }
        // FIXME: Add page tracking
    }
}

// MARK: - TopNavigationBarDelegate

extension LearnContentItemCoordinator: TopNavigationBarDelegate {

    func topNavigationBar(_ navigationBar: TopNavigationBar, leftButtonPressed button: UIBarButtonItem) {
        topTabBarController.dismiss(animated: true, completion: nil)
        if AppCoordinator.currentStatusBarStyle != nil {
            AppCoordinator.updateStatusBarStyleIfNeeded()
        } else {
            UIApplication.shared.statusBarStyle = .lightContent
        }
    }
    
    func topNavigationBar(_ navigationBar: TopNavigationBar, middleButtonPressed button: UIButton, withIndex index: Int, ofTotal total: Int) {
        guard let pageViewController = topTabBarController.viewControllers.first as? PageViewController else {
            return
        }
        
        pageViewController.setPageIndex(index, animated: true)
    }
    
    func topNavigationBar(_ navigationBar: TopNavigationBar, rightButtonPressed button: UIBarButtonItem) {
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

    func didTapPDF(withURL url: URL, in viewController: LearnContentItemViewController) {
        do {
            // FIXME: apple bug. perhaps because this gets displayed on WindowManager.Level.priority
            // https://stackoverflow.com/questions/46439142/sfsafariviewcontroller-blank-in-ios-11-xcode-9-0
            // https://openradar.appspot.com/29108332
            let vc = try WebViewController(url)
            viewController.present(vc, animated: true, completion: nil)
        } catch {
            log("Failed to open url. Error: \(error)")
            viewController.showAlert(type: .message(error.localizedDescription))
        }
    }
}

// MARK: - PageViewControllerDelegate

extension LearnContentItemCoordinator: PageViewControllerDelegate {

    func pageViewController(_ controller: UIPageViewController, didSelectPageIndex index: Int) {
        guard let navigationController = controller.navigationController, let topNavigationBar = navigationController.navigationBar as? TopNavigationBar else {
            return
        }
        topNavigationBar.setIndicatorToButtonIndex(index)
    }
}
