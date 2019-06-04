//
//  ArticleContentItemCoordinator.swift
//  QOT
//
//  Created by karmic on 22.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import AVKit
import RealmSwift
import AVFoundation

final class ArticleContentItemCoordinator: ParentCoordinator {

    private let services: Services
    private var articleHeader: ArticleCollectionHeader?
    private let topTabBarTitle: String?
    private var selectedContent: ContentCollection?
    private var viewModel: ArticleItemViewModel
    private let rootViewController: UIViewController
    private let shouldPush: Bool
    private let isSearch: Bool
    private let guideItem: Guide.Item?
    private var avPlayerObserver: AVPlayerObserver?
    let pageName: PageName
    var children: [Coordinator] = []
    var topTabBarController: UINavigationController?
    var fullViewController: ArticleItemViewController

    init?(pageName: PageName,
          root: UIViewController,
          services: Services,
          contentCollection: ContentCollection?,
          articleHeader: ArticleCollectionHeader? = nil,
          topTabBarTitle: String?,
          topSmallTitle: String? = nil,
          backgroundImage: UIImage? = nil,
          shouldPush: Bool = true,
          isSearch: Bool = false,
          contentInsets: UIEdgeInsets = UIEdgeInsets(top: 53, left: 0, bottom: 0, right: 0),
          guideItem: Guide.Item? = nil) {
        guard let contentCollection = contentCollection else { return nil }
        self.pageName = pageName
        self.rootViewController = root
        self.services = services
        self.articleHeader = articleHeader
        self.selectedContent = contentCollection
        self.topTabBarTitle = topTabBarTitle
        self.shouldPush = shouldPush
        self.isSearch = isSearch
        self.guideItem = guideItem
        let articleItems = Array(contentCollection.articleItems)
        viewModel = ArticleItemViewModel(services: services,
                                         items: articleItems,
                                         contentCollection: contentCollection,
                                         articleHeader: articleHeader,
                                         backgroundImage: backgroundImage,
                                         topSmallTitle: topSmallTitle)
        ArticleItemViewController.page = pageName
        fullViewController = ArticleItemViewController(viewModel: viewModel,
                                                       guideItem: guideItem,
                                                       contentInsets: contentInsets,
                                                       fadeMaskLocation: .top)
        let title = viewModel.isWhatsHot == true ? R.string.localized.topTabBarItemTitleLearnWhatsHot() : topTabBarTitle
        fullViewController.title = title
        fullViewController.delegate = self
        if shouldPush == false {
            topTabBarController = UINavigationController(withPages: [fullViewController],
                                                         navigationItem: NavigationItem(),
                                                         topBarDelegate: self,
                                                         leftButton: UIBarButtonItem(withImage: R.image.ic_close()))
        }
    }

    func start() {
        guard selectedContent != nil else { return }
        if isSearch == true {
            rootViewController.pushToStart(childViewController: fullViewController)
        } else if shouldPush == false, let navigationController = topTabBarController {
            rootViewController.present(navigationController, animated: true)
        } else {
            rootViewController.pushToStart(childViewController: fullViewController)
            fullViewController.setCustomBackButton()
        }
        // FIXME: Add page tracking
    }
}

// MARK: - TopNavigationBarDelegate

extension ArticleContentItemCoordinator: NavigationItemDelegate {

    func navigationItem(_ navigationItem: NavigationItem, leftButtonPressed button: UIBarButtonItem) {
        AppDelegate.topViewController()?.dismiss(animated: true, completion: nil)
    }

    func navigationItem(_ navigationItem: NavigationItem, middleButtonPressedAtIndex index: Int, ofTotal total: Int) {}

    func navigationItem(_ navigationItem: NavigationItem, rightButtonPressed button: UIBarButtonItem) {}

    func navigationItem(_ navigationItem: NavigationItem, searchButtonPressed button: UIBarButtonItem) {}
}

// MARK: - ArticleItemViewControllerDelegate

extension ArticleContentItemCoordinator: ArticleItemViewControllerDelegate {

    func didTapShare(header: ArticleCollectionHeader) {
        let whatsHotShareable = WhatsHotShareable(message: header.articleSubTitle,
                                                  imageURL: header.thumbnail,
                                                  shareableLink: header.shareableLink)
        let activityVC = UIActivityViewController(activityItems: [whatsHotShareable], applicationActivities: nil)
        fullViewController.present(activityVC, animated: true, completion: nil)
    }

    func didSelectRelatedArticle(selectedArticle: ContentCollection, form viewController: UIViewController) {
        self.selectedContent = selectedArticle
        if selectedArticle.section == Database.Section.learnStrategy.rawValue,
            let contentID = selectedArticle.remoteID.value,
            let categoryID = selectedArticle.categoryIDs.first?.value {
            AppDelegate.current.appCoordinator.presentLearnContentItems(contentID: contentID, categoryID: categoryID)
            return
        }
        articleHeader = ArticleCollectionHeader(content: selectedArticle, displayDate: nil)
        viewModel = ArticleItemViewModel(services: services,
                                         items: Array(selectedArticle.articleItems),
                                         contentCollection: selectedArticle,
                                         articleHeader: articleHeader)
        let topInset = fullViewController.view.bounds.height * Layout.multiplier_025
        let edgeInsets = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
        ArticleItemViewController.page = .whatsHotArticle
        let relatedArticleViewController = ArticleItemViewController(viewModel: viewModel,
                                                                     contentInsets: edgeInsets,
                                                                     fadeMaskLocation: .top)
        relatedArticleViewController.delegate = self
        let navigationController = UINavigationController(withPages: [relatedArticleViewController],
                                                          navigationItem: NavigationItem(),
                                                          topBarDelegate: self,
                                                          leftButton: UIBarButtonItem(withImage: R.image.ic_close()))
        viewController.present(navigationController, animated: true) {
            self.viewModel.markContentAsRead()
        }
    }

    func didTapPDFLink(_ title: String?, _ itemID: Int, _ url: URL, in viewController: UIViewController) {
        let storyboard = UIStoryboard(name: "PDFReaderViewController", bundle: nil)
        guard let navigationController = storyboard.instantiateInitialViewController() as? UINavigationController else {
            return
        }
        guard let readerViewController = navigationController.viewControllers.first as? PDFReaderViewController else {
            return
        }
        let pdfReaderConfigurator = PDFReaderConfigurator.make(contentItemID: itemID, title: title ?? "", url: url)
        pdfReaderConfigurator(readerViewController)
        viewController.present(navigationController, animated: true, completion: nil)
    }

    func didTapLink(_ url: URL, in viewController: UIViewController) {
        if url.scheme == "mailto" && UIApplication.shared.canOpenURL(url) == true {
            UIApplication.shared.open(url)
        } else {
            do {
                viewController.present(try WebViewController(url), animated: true, completion: nil)
            } catch {
                log("Failed to open url. Error: \(error)", level: .error)
                viewController.showAlert(type: .message(error.localizedDescription))
            }
        }
    }

    func didTapClose(in viewController: UIViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }

    func didTapMedia(withURL url: URL, in viewController: UIViewController) {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        } catch let error {
            log("Error while trying to set catgeory for AVAudioSession: \(error)", level: .error)
        }

        let currentPage = ArticleItemViewController.page
        let playerViewController = viewController.stream(videoURL: url,
                                                         contentItem: viewModel.articleItemVideo(for: url),
                                                         pageName: currentPage)
        if let playerItem = playerViewController.player?.currentItem {
            avPlayerObserver = AVPlayerObserver(playerItem: playerItem)
            avPlayerObserver?.onStatusUpdate { (player) in
                if playerItem.error != nil {
                    playerViewController.presentNoInternetConnectionAlert(in: playerViewController)
                }
            }
        }
    }
}

// // MARK: - Private / UIActivityItemSource

final class WhatsHotShareable: NSObject, UIActivityItemSource {
    var message: String
    var imageURL: URL?
    var shareableLink: String?

    init(message: String, imageURL: URL?, shareableLink: String?) {
        self.message = message
        self.imageURL = imageURL
        self.shareableLink = shareableLink
    }

    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        if let shareableLink = shareableLink {
            return URL(string: shareableLink) ?? message
        }
        return message
    }

    func activityViewController(_ activityViewController: UIActivityViewController,
                                itemForActivityType activityType: UIActivityType?) -> Any? {
        if let shareableLink = shareableLink {
            return URL(string: shareableLink)
        }
        return shareableLink
    }

    func activityViewController(_ activityViewController: UIActivityViewController,
                                subjectForActivityType activityType: UIActivityType?) -> String {
        return message
    }

    func activityViewController(_ activityViewController: UIActivityViewController,
                                thumbnailImageForActivityType activityType: UIActivityType?,
                                suggestedSize size: CGSize) -> UIImage? {
        if let imageURL = imageURL, let data = try? Data(contentsOf: imageURL) {
            return UIImage(data: data)
        }
        return nil
    }
}
