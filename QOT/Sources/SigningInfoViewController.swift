//
//  SigningInfoViewController.swift
//  QOT
//
//  Created by karmic on 28.05.18.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import UIKit

final class SigningInfoViewController: UIViewController {

    // MARK: - Properties

    var interactor: SigningInfoInteractorInterface?
    private var timer: Timer?
    @IBOutlet private weak var bottomButton: UIButton!
    @IBOutlet private weak var pageControl: PageControl!
    @IBOutlet private weak var collectionView: UICollectionView!

    // MARK: - Init

    init(configure: Configurator<SigningInfoViewController>) {
        super.init(nibName: nil, bundle: nil)
        configure(self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupAutoScroll()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
    }
}

// MARK: - Private

private extension SigningInfoViewController {

    func setupButtons() {
        let attributedTitle = NSMutableAttributedString(string: "Sign In",
                                                        letterSpacing: 0.8,
                                                        font: Font.DPText,
                                                        textColor: .white90,
                                                        alignment: .left)
        bottomButton.backgroundColor = .azure
        bottomButton.corner(radius: Layout.CornerRadius.defaultEight.rawValue)
        bottomButton.setAttributedTitle(attributedTitle, for: .normal)
        bottomButton.setAttributedTitle(attributedTitle, for: .selected)
    }

    func setupCollectionView() {
        collectionView.registerDequeueable(SigningInfoCollectionViewCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    func setupAutoScroll() {
        timer = Timer.scheduledTimer(withTimeInterval: 12, repeats: true) { [unowned self] (_) in
            let nextItem = self.currentPageIndex() + 1 < SigningInfoModel.Slide.allSlides.count ? self.currentPageIndex() + 1 : 0
            let indexPath = IndexPath(item: nextItem, section: 0)
            UIView.animate(withDuration: 0.8) { [weak self] in
                self?.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            }
        }
    }

    func currentPageIndex() -> Int {
        let pageWidth = collectionView.frame.size.width
        let centerOffsetX = collectionView.contentOffset.x + (pageWidth * 0.5)
        let page = Int(centerOffsetX / pageWidth)
        return page.constrainedTo(min: 0, max: SigningInfoModel.Slide.allSlides.count - 1)
    }

    func syncControlsForCurrentPage() {
        let index = currentPageIndex()
        syncPageControl(page: index)
    }

    func syncPageControl(page: Int) {
        pageControl.currentPage = page
    }
}

// MARK: - Actions

private extension SigningInfoViewController {

    @IBAction func didTapBottomButton() {
        interactor?.didTapBottomButton()
    }
}

// MARK: - SigningInfoViewControllerInterface

extension SigningInfoViewController: SigningInfoViewControllerInterface {

    func setup() {
        setupButtons()
        setupCollectionView()
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension SigningInfoViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SigningInfoModel.Slide.allSlides.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: SigningInfoCollectionViewCell = collectionView.dequeueCell(for: indexPath)
        let title = SigningInfoModel.Slide.allSlides[indexPath.item].title
        let body = SigningInfoModel.Slide.allSlides[indexPath.item].body
        cell.configure(title: title, body: body)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: collectionView.frame.height - 100)
    }
}

extension SigningInfoViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        syncControlsForCurrentPage()
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
    }

    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        setupAutoScroll()
    }
}
