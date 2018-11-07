//
//  SlideShowViewController.swift
//  QOT
//
//  Created by Sam Wyndham on 12.12.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Anchorage

final class SlideShowViewController: UIViewController {

    @IBOutlet private weak var closeBarButtonItem: UIBarButtonItem!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var pageControl: UIPageControl!
    @IBOutlet private weak var doneButton: UIButton!
    @IBOutlet private weak var navigationBar: UINavigationBar!
    private var pages: [SlideShow.Page] = []
    private var type: SlidesType?
    var interactor: SlideShowInteractorInterface!

    init(configure: Configurator<SlideShowViewController>, type: SlidesType) {
        super.init(nibName: nil, bundle: nil)
        configure(self)
        self.type = type
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setCustomBackButton()
        view.backgroundColor = .navy
        interactor.viewDidLoad()
        collectionView.registerDequeueable(SlideShowTitleSubtitleSlideCell.self)
        collectionView.registerDequeueable(SlideShowTitleOnlySlideCell.self)
        collectionView.registerDequeueable(SlideShowCompletePromptCell.self)
        navigationBar.applyNavyStyle()
        navigationBar.topItem?.title = R.string.localized.sidebarTitleIntroSliders().uppercased()
        navigationBar.titleTextAttributes = [.font: UIFont.H5SecondaryHeadline,
                                             .foregroundColor: UIColor.white]
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @IBAction func didTapDoneButton() {
        interactor.didTapDone()
    }

    @IBAction func didTapClose(_ sender: UIBarButtonItem) {
        interactor.didTapDone()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
}

extension SlideShowViewController: SlideShowViewControllerInterface {

    func setPages(_ pages: [SlideShow.Page]) {
        setPagesAndSyncControls(pages: pages)
        collectionView.reloadData()
    }

    func updatePages(_ pages: [SlideShow.Page]) {
        setPagesAndSyncControls(pages: pages)
    }
}

extension SlideShowViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pages.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let page = pages[indexPath.item]
        switch page {
        case .titleSubtitleSlide(let title, let subtitle, let imageURL):
            let cell: SlideShowTitleSubtitleSlideCell = collectionView.dequeueCell(for: indexPath)
            cell.configure(title: title, subtitle: subtitle, imageURL: imageURL)
            return cell
        case .titleSlide(let title, let imageURL):
            let cell: SlideShowTitleOnlySlideCell = collectionView.dequeueCell(for: indexPath)
            cell.configure(title: title, imageURL: imageURL)
            return cell
        case .completePrompt:
            let cell: SlideShowCompletePromptCell = collectionView.dequeueCell(for: indexPath)
            cell.delegate = self
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        syncControlsForCurrentPage()
    }
}

extension SlideShowViewController: SlideShowPromtCellDelegate {

    func didTapDone(cell: UICollectionViewCell) {
        interactor.didTapDone()
    }
}

private extension SlideShowViewController {

    func setPagesAndSyncControls(pages: [SlideShow.Page]) {
        self.pages = pages
        pageControl.numberOfPages = pages.count
        syncControlsForCurrentPage()
    }

    func syncControlsForCurrentPage() {
        let index = currentPageIndex()
        syncPageControl(page: index)
        syncDoneButton(page: index)
    }

    func syncPageControl(page: Int) {
        pageControl.currentPage = page
    }

    func syncDoneButton(page: Int) {
        switch type {
        case .initialInstall?:
            let isLastPage = pageControl.numberOfPages == page + 1
            let title = isLastPage ? "Start" : "Close"
            doneButton.setTitle(title, for: .normal)
            closeBarButtonItem.isEnabled = false
            closeBarButtonItem.image = nil
            closeBarButtonItem.title = ""
        case .helpMenu?:
            doneButton.isHidden = true
        case .none:
            return
        }
    }

    func currentPageIndex() -> Int {
        guard pages.count > 0 else { return 0 }
        let pageWidth = collectionView.frame.size.width
        let centerOffsetX = collectionView.contentOffset.x + (pageWidth / 2)
        let page = Int(centerOffsetX / pageWidth)
        return page.constrainedTo(min: 0, max: pages.count - 1)
    }
}
