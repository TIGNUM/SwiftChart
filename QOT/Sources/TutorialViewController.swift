//
//  TutorialViewController.swift
//  QOT
//
//  Created by karmic on 16.11.18.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import UIKit

enum TutorialOrigin {
    case login
    case settings
}

final class TutorialViewController: UIViewController {

    // MARK: - Properties

    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var endButton: UIButton!
    @IBOutlet private weak var pageControl: UIPageControl!
    @IBOutlet private weak var controlView: UIView!
    private var origin: TutorialOrigin = .login
    var interactor: TutorialInteractorInterface?

    // MARK: - Init

    init(configure: Configurator<TutorialViewController>, from origin: TutorialOrigin) {
        super.init(nibName: nil, bundle: nil)
        self.origin = origin
        configure(self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackPage()
    }
}

// MARK: - Private

private extension TutorialViewController {

    func setupView() {
        view.backgroundColor = .navy
        controlView.backgroundColor = .navy
        endButton.isHidden = origin == .settings
    }

    func setupNavigationBar() {
        title = R.string.localized.topTabBarItemTitleTutorial()
    }

    func setupCollectionView() {
        collectionView.backgroundColor = .navy
        collectionView.registerDequeueable(TutorialCollectionViewCell.self)
        collectionView.reloadData()
    }

    func setupPageControl() {
        pageControl.numberOfPages = interactor?.numberOfSlides ?? 0
    }

    func setupEndButton(at index: Index) {
        endButton.setAttributedTitle(interactor?.attributedbuttonTitle(at: index, for: origin), for: .normal)
    }

    func syncControlsForCurrentPage() {
        let index = currentPageIndex()
        pageControl.currentPage = index
        setupEndButton(at: index)
        endButton.isHidden = origin == .login ? false : index + 1 != interactor?.numberOfSlides
    }

    func currentPageIndex() -> Int {
        guard let pages = interactor?.numberOfSlides, pages > 0 else { return 0 }
        let pageWidth = collectionView.frame.size.width
        let centerOffsetX = collectionView.contentOffset.x + (pageWidth / 2)
        let page = Int(centerOffsetX / pageWidth)
        return page.constrainedTo(min: 0, max: pages - 1)
    }
}

// MARK: - Actions

private extension TutorialViewController {

    @IBAction func didTapEndButton() {
        interactor?.dismiss()
    }
}

// MARK: - TutorialViewControllerInterface

extension TutorialViewController: TutorialViewControllerInterface {

    func setup() {
        setupNavigationBar()
        setupView()
        setupCollectionView()
        setupPageControl()
        syncControlsForCurrentPage()
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension TutorialViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return interactor?.numberOfSlides ?? 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: TutorialCollectionViewCell = collectionView.dequeueCell(for: indexPath)
        cell.configure(title: interactor?.title(at: indexPath.item),
                       subtitle: interactor?.subtitle(at: indexPath.item),
                       body: interactor?.body(at: indexPath.item),
                       imageURL: interactor?.imageURL(at: indexPath.item))
        return cell
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        syncControlsForCurrentPage()
    }
}
