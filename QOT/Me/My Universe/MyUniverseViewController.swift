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
    fileprivate var backgroundScrollView: UIScrollView?
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

// MARK: - TabRecognizer Helper

private extension MyUniverseViewController {

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
                    return myDataViewModel.sectors.last                }
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

// MARK: - SubViews

private extension MyUniverseViewController {

    func addSubViews() {
        addMyWhyView()
        addMyDataSectorLabelView()
        addMySolarView()
    }

    func addMyWhyView() {
        let myWhyViewFrame = CGRect(x: view.bounds.width, y: 0, width: view.bounds.width, height: view.bounds.height)
        let myWhyView = MyWhyView(myWhyViewModel: myWhyViewModel, frame: myWhyViewFrame)
        contentScrollView?.addSubview(myWhyView)
    }

    func addMySolarView() {
        let solarView = MeSolarView(sectors: myDataViewModel.sectors, profileImage: myDataViewModel.profileImage, frame: view.bounds)
        contentScrollView?.addSubview(solarView)
        self.solarView = solarView
    }

    func addMyDataSectorLabelView() {
        let myDataSectorLablesViewFrame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        let myDataSectorLabelsView = MyDataSectorLabelsView(sectors: myDataViewModel.sectors, frame: myDataSectorLablesViewFrame)
        contentScrollView?.addSubview(myDataSectorLabelsView)
    }
}

// MARK: - ScrollViews

private extension MyUniverseViewController {

    func setupScrollViews() {
        let layout = Layout.MeSection(viewControllerFrame: view.bounds)
        setupBackgroundScrollView(layout: layout)
        setupContentScrollView(layout: layout)
    }

    func setupBackgroundScrollView(layout: Layout.MeSection) {
        let backgroundScrollView = MyUniverseHelper.createScrollView(view.frame, layout: layout)
        backgroundScrollView.isUserInteractionEnabled = false
        backgroundScrollView.delegate = nil
        addBackgroundImage(scrollView: backgroundScrollView)
        view.addSubview(backgroundScrollView)
        self.backgroundScrollView = backgroundScrollView
    }

    func setupContentScrollView(layout: Layout.MeSection) {
        let contentScrollView = MyUniverseHelper.createScrollView(view.frame, layout: layout)
        contentScrollView.delegate = self
        view.addSubview(contentScrollView)
        self.contentScrollView = contentScrollView
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
}

// MARK: - View Effect ProfileImageView

private extension MyUniverseViewController {

    func updateProfileImageViewAlphaValue(_ contentScrollView: UIScrollView) {
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

// MARK: - View Effect Parallax

private extension MyUniverseViewController {

    func setParallaxEffect(_ contentScrollView: UIScrollView) {
        let backgroundContentOffset = CGPoint(x: contentScrollView.contentOffset.x * 1.2, y: contentScrollView.contentOffset.y)
        backgroundScrollView?.setContentOffset(backgroundContentOffset, animated: false)
    }
}
