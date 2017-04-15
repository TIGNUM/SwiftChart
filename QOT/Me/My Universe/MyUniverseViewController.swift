//
//  MyUniverseViewController.swift
//  QOT
//
//  Created by karmic on 22/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

protocol MyUniverseViewControllerDelegate: class {
    func didTapSector(sector: Sector?, in viewController: UIViewController)
}

final class MyUniverseViewController: UIViewController {
    
    // MARK: - Properties

    fileprivate let myDataViewModel: MyDataViewModel
    fileprivate let myWhyViewModel: MyWhyViewModel
    fileprivate var contentScrollView: UIScrollView?
    fileprivate var parallaxEffectScrollView: UIScrollView?
    fileprivate var solarView: MeSolarView?
    fileprivate var myWhyView: MyWhyView?
    weak var delegate: MyUniverseViewControllerDelegate?

    // MARK: - Life Cycle

    init(myDataViewModel: MyDataViewModel, myWhyViewModel: MyWhyViewModel) {
        self.myDataViewModel = myDataViewModel
        self.myWhyViewModel = myWhyViewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupScrollViews()
        addSubViews()
        addTabRecognizer()
    }
}

// MARK: - TabRecognizer

private extension MyUniverseViewController {

    func addTabRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapSector))
        view?.addGestureRecognizer(tapGestureRecognizer)
    }

    @objc func didTapSector(recognizer: UITapGestureRecognizer) {
        delegate?.didTapSector(sector: sector(location: recognizer.location(in: view)), in: self)
    }
}

// MARK: - Helpers

private extension MyUniverseViewController {

    func addSubViews() {
        let myWhyViewFrame = CGRect(x: view.bounds.width, y: 0, width: view.bounds.width, height: view.bounds.height)
        contentScrollView?.addSubview(MyWhyView(myWhyViewModel: myWhyViewModel, frame: myWhyViewFrame))
        let solarView = MeSolarView(sectors: myDataViewModel.sectors, profileImage: myDataViewModel.profileImage, frame: view.bounds)
        contentScrollView?.addSubview(solarView)
        self.solarView = solarView
    }

    func sector(location: CGPoint) -> Sector? {
        let radius = lengthFromCenter(for: location)
        let yPosShifted = location.y - (solarView?.profileImageView.center.y ?? 0)
        let xPosShifted = location.x - (solarView?.profileImageView.center.x ?? 0)
        let beta = acos(xPosShifted / radius)
        let sectorAngle = beta.radiansToDegrees

        for (_, sector) in myDataViewModel.sectors.enumerated() {
            if yPosShifted >= 0 {
                if sector.startAngle ... sector.endAngle ~= sectorAngle {
                    return sector
                }

                if sectorAngle < 100 {
                    return myDataViewModel.sectors.last
                }
            } else {
                let mappedSectorAngle = 180 + (180 - sectorAngle)
                if sector.startAngle ... sector.endAngle ~= mappedSectorAngle {
                    return sector
                }

                if sectorAngle < 100 {
                    return myDataViewModel.sectors.first
                }
            }
        }

        return nil
    }

    func lengthFromCenter(for location: CGPoint) -> CGFloat {
        let diffX = pow(location.x - (solarView?.profileImageView.center.x ?? 0), 2)
        let diffY = pow(location.y - (solarView?.profileImageView.center.y ?? 0), 2)
        
        return sqrt(diffX + diffY)
    }
}

// MARK: - ScrollViews

private extension MyUniverseViewController {

    func setupScrollViews() {
        setupParallaxEffectScrollView()
        setupContentScrollView()
    }

    func setupParallaxEffectScrollView() {
        let parallaxEffectScrollView = createScrollView()
        parallaxEffectScrollView.isUserInteractionEnabled = false        
        parallaxEffectScrollView.delegate = nil
        addBackgroundImage(scrollView: parallaxEffectScrollView)
        view.addSubview(parallaxEffectScrollView)
        self.parallaxEffectScrollView = parallaxEffectScrollView
    }

    func setupContentScrollView() {
        let contentScrollView = createScrollView()
        contentScrollView.delegate = self
        view.addSubview(contentScrollView)
        self.contentScrollView = contentScrollView
    }

    func createScrollView() -> UIScrollView {
        let layout = Layout.MeSection(viewControllerFrame: view.bounds)
        let scrollView = UIScrollView(frame: view.frame)
        scrollView.bounces = false
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentSize = CGSize(
            width: (view.frame.width * 2) - (layout.scrollViewOffset * 3.5),
            height: view.frame.height - 84
            // TODO: Change it when the tabBar is all setup corectly with bottomLayout.
        )
        return scrollView
    }

    func addBackgroundImage(scrollView: UIScrollView) {
        let frame = CGRect(x: view.frame.minX, y: view.frame.minY, width: view.frame.width * 2, height: view.frame.height)
        let imageView = UIImageView(frame: frame)
        imageView.image = R.image.solarSystemBackground()
        scrollView.addSubview(imageView)
    }
}

// MARK: - ScrollViewDelegate

extension MyUniverseViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        setParallaxEffect(scrollView)
        updateProfileImageViewAlphaValue(scrollView)
    }

    private func setParallaxEffect(_ contentScrollView: UIScrollView) {
        let contentOffset = CGPoint(x: contentScrollView.contentOffset.x * 1.2, y: contentScrollView.contentOffset.y)
        parallaxEffectScrollView?.setContentOffset(contentOffset, animated: false)
    }

    private func updateProfileImageViewAlphaValue(_ contentScrollView: UIScrollView) {
        let maxX = contentScrollView.frame.maxX - view.frame.width * 0.24
        guard maxX > 0 else {
            solarView?.profileImageViewOverlay.alpha = 0
            solarView?.profileImageViewOverlayEffect.alpha = 0
            return
        }

        let alpha = 1 - (contentScrollView.contentOffset.x/maxX)
        solarView?.profileImageViewOverlay.alpha = alpha
        solarView?.profileImageViewOverlayEffect.alpha = alpha
    }
}
