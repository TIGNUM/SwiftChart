//
//  SigningInfoViewController.swift
//  QOT
//
//  Created by karmic on 28.05.18.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import UIKit

final class SigningInfoViewController: UIViewController, ScreenZLevelOverlay {

    // MARK: - Properties
    var interactor: SigningInfoInteractorInterface?
    private var timer: Timer?
    @IBOutlet private weak var webView: UIWebView!
    @IBOutlet private weak var bottomButton: UIButton!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var startButton: UIButton!
    @IBOutlet private weak var pageControl: PageControl!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var headerBackgroundView: UIView!
    var delegate: SigningInfoDelegate?

    // MARK: - Init
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.viewDidLoad()
        NotificationHandler.postNotification(withName: .showSigningInfoView)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackPage()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        setupAutoScroll()
        refreshBottomNavigationItems()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()

        UIView.animate(withDuration: Animation.duration_03) {
            self.view.alpha = 0
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        view.alpha = 1
    }

    override func bottomNavigationLeftBarItems() -> [UIBarButtonItem]? {
        return nil
    }

    override func bottomNavigationRightBarItems() -> [UIBarButtonItem]? {
        return nil
    }
}

// MARK: - Private
private extension SigningInfoViewController {
    func setupButtons() {
        let attributedTitle = NSMutableAttributedString(string: "Sign In",
                                                        letterSpacing: 0.8,
                                                        font: .DPText,
                                                        textColor: .white90,
                                                        alignment: .left)
        bottomButton.backgroundColor = .azure
        bottomButton.corner(radius: Layout.CornerRadius.eight.rawValue)
        bottomButton.setAttributedTitle(attributedTitle, for: .normal)
        bottomButton.setAttributedTitle(attributedTitle, for: .selected)

        ThemeBorder.accent.apply(loginButton)
        ThemeBorder.accent.apply(startButton)
    }

    func setupCollectionView() {
        collectionView.registerDequeueable(SigningInfoCollectionViewCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    func setupAutoScroll() {
        timer = Timer.scheduledTimer(withTimeInterval: Animation.duration_6, repeats: true) { [unowned self] (_) in
            let nextItem = self.currentPageIndex() + 1 < SigningInfoModel.Slide.allSlides.count ? self.currentPageIndex() + 1 : 0
            let indexPath = IndexPath(item: nextItem, section: 0)
            UIView.animate(withDuration: 0.8) { [weak self] in
                self?.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            }
        }
    }

    func setupWebViewBackground() {
        headerBackgroundView.backgroundColor = .clear
        view.backgroundColor = .navy
        webView.backgroundColor = .navy
        let htmlPath = Bundle.main.path(forResource: "WebViewContent", ofType: "html")
        let htmlURL = URL(fileURLWithPath: htmlPath!)
        let html = try? Data(contentsOf: htmlURL)
        webView.load(html!, mimeType: "text/html",
                          textEncodingName: "UTF-8",
                          baseURL: htmlURL.deletingLastPathComponent())
        webView.scalesPageToFit = true
        webView.contentMode = .scaleAspectFit
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

    @IBAction func didTapLogin() {
        interactor?.didTapLoginButton()
    }

    @IBAction func didTapStart() {
        //TODO: https://tignum.atlassian.net/browse/QOT-1625
        interactor?.didTapStartButton()
    }
}

// MARK: - SigningInfoViewControllerInterface
extension SigningInfoViewController: SigningInfoViewControllerInterface {
    func setup() {
        setupWebViewBackground()
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
        cell.configure(title: interactor?.title(at: indexPath.item), body: interactor?.body(at: indexPath.item))
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
