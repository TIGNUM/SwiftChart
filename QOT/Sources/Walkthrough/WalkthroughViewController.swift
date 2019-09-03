//
//  WalkthroughViewController.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 22/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class WalkthroughViewController: UIViewController, ScreenZLevelOverlay {

    // MARK: - Properties
    @IBOutlet private weak var pageContainerView: UIView!
    @IBOutlet private weak var pageIndicatorView: UIView!
    @IBOutlet private weak var buttonGotIt: UIButton!

    private let gotItAppearDelay: Double = 2
    private let animationDuration: Double = Animation.duration_3
    private let pageIndicator = MyToBeVisionPageComponentView()
    private var pageController: UIPageViewController?
    private var timer: Timer?
    private var viewedControllers = Set<Int>() {
        didSet {
            checkViewedControllers()
        }
    }

    var interactor: WalkthroughInteractorInterface?

    // MARK: - Init

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presetTimer()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        invalidateTimer()
    }
}

// MARK: - Private

private extension WalkthroughViewController {

    func presetTimer() {
        invalidateTimer()
        timer = Timer.scheduledTimer(withTimeInterval: animationDuration, repeats: true) { [unowned self] (_) in
            self.goToNextController()
        }
    }

    func invalidateTimer() {
        timer?.invalidate()
        timer = nil
    }

    func goToNextController() {
        guard let current = pageController?.viewControllers?.first,
            let next = interactor?.viewController(after: current) else { return }
        viewedControllers.insert(next.hash)
        show(controller: next)
    }

    func checkViewedControllers() {
        guard buttonGotIt.isHidden, viewedControllers.count == interactor?.controllerCount ?? 0 else { return }
        buttonGotIt.alpha = 0
        buttonGotIt.isHidden = false
        let duration = Animation.duration_04
        UIView.animate(withDuration: duration, delay: gotItAppearDelay, options: .curveEaseInOut, animations: {
            self.buttonGotIt.alpha = 1
        })
    }
}

// MARK: - Actions

private extension WalkthroughViewController {

    @IBAction func didTapGotItButton() {
        interactor?.didTapGotIt()
    }
}

// MARK: - WalkthroughViewControllerInterface

extension WalkthroughViewController: WalkthroughViewControllerInterface {

    func setupView() {
        ThemeView.onboarding.apply(view)

        pageIndicator.translatesAutoresizingMaskIntoConstraints = false
        pageIndicatorView?.addSubview(pageIndicator)
        pageIndicator.addConstraints(to: pageIndicatorView)
        pageIndicator.pageColor = .sand
        pageIndicator.pageCount = interactor?.controllerCount ?? 3
        pageIndicator.currentPageIndex = 0

        let pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageController.delegate = self
        pageController.dataSource = self
        self.pageController = pageController
        pageContainerView.addSubview(pageController.view)
        pageContainerView.fill(subview: pageController.view)
        self.addChildViewController(pageController)

        if let controller = interactor?.firstController {
            viewedControllers.insert(controller.hash)
            pageController.setViewControllers([controller], direction: .forward, animated: false, completion: nil)
        }

        buttonGotIt.corner(radius: buttonGotIt.bounds.size.height * 0.5, borderColor: .accent70)
    }

    func show(controller: UIViewController) {
        pageController?.setViewControllers([controller], direction: .forward, animated: true, completion: nil)
        pageIndicator.currentPageIndex = interactor?.index(of: controller) ?? 0
    }
}

// MARK: - UIPageViewControllerDelegate

extension WalkthroughViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController,
                            willTransitionTo pendingViewControllers: [UIViewController]) {
        pageIndicator.currentPageIndex = interactor?.index(of: pendingViewControllers.first) ?? 0
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        pageIndicator.currentPageIndex = interactor?.index(of: pageViewController.viewControllers?.first) ?? 0
        if let hash = pageViewController.viewControllers?.first?.hash {
            viewedControllers.insert(hash)
        }
        presetTimer()
    }
}

// MARK: - UIPageViewControllerDataSource

extension WalkthroughViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return interactor?.viewController(before: viewController)
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return interactor?.viewController(after: viewController)
    }
}
