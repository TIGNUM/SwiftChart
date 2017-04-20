//
//  MyUniverseViewController.swift
//  QOT
//
//  Created by karmic on 22/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

protocol MyUniverseViewControllerDelegate: class {
    func didTapSector(sector: Sector?, in viewController: MyUniverseViewController)
    func didTapMyToBeVision(vision: Vision?, in viewController: MyUniverseViewController)
    func didTapWeeklyChoices(weeklyChoice: WeeklyChoice?, in viewController: MyUniverseViewController)
    func didTypQOTPartner(partner: Partner?, in viewController: MyUniverseViewController)
}

protocol MyUniverseContentScrollViewDelegate: class {
    func didScrollToMyData()
    func didScrollToMyWhy()
}

final class MyUniverseViewController: UIViewController {
    
    // MARK: - Properties

    fileprivate let myDataViewModel: MyDataViewModel
    fileprivate let myWhyViewModel: MyWhyViewModel
    fileprivate var backgroundScrollView: UIScrollView?
    fileprivate var myDataView: MyDataView?
    fileprivate var myWhyView: MyWhyView?
    fileprivate var myDataSectorLabelsView: MyDataSectorLabelsView?
    fileprivate var lastContentOffset: CGFloat = 0
    weak var delegate: MyUniverseViewControllerDelegate?
    weak var contentScrollViewDelegate: MyUniverseContentScrollViewDelegate?
    var contentScrollView: UIScrollView?

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
        let yPosShifted = location.y - (myDataView?.profileImageView.center.y ?? 0)
        let xPosShifted = location.x - (myDataView?.profileImageView.center.x ?? 0)
        let beta = acos(xPosShifted / radius)
        let sectorAngle = beta.radiansToDegrees

        for (_, sector) in myDataViewModel.sectors.enumerated() {
            if yPosShifted >= 0 {
                if sector.startAngle ... sector.endAngle ~= sectorAngle {
                    return sector
                }

                if sectorAngle < 119 {
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
        let diffX = pow(location.x - (myDataView?.profileImageView.center.x ?? 0), 2)
        let diffY = pow(location.y - (myDataView?.profileImageView.center.y ?? 0), 2)
        
        return sqrt(diffX + diffY)
    }
}

// MARK: - SubViews

private extension MyUniverseViewController {

    func addSubViews() {
        addMyWhyView()
        addMyDataSectorLabelView()
        addMyDataView()
    }

    func addMyWhyView() {
        let myWhyViewFrame = CGRect(x: view.bounds.width, y: 0, width: view.bounds.width, height: view.bounds.height)
        let myWhyView = MyWhyView(myWhyViewModel: myWhyViewModel, frame: myWhyViewFrame, viewController: self, delegate: delegate)
        contentScrollView?.addSubview(myWhyView)
        self.myWhyView = myWhyView
    }

    func addMyDataSectorLabelView() {
        let myDataSectorLablesViewFrame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        let myDataSectorLabelsView = MyDataSectorLabelsView(sectors: myDataViewModel.sectors, frame: myDataSectorLablesViewFrame)
        contentScrollView?.addSubview(myDataSectorLabelsView)
        self.myDataSectorLabelsView = myDataSectorLabelsView
    }

    func addMyDataView() {
        let myDataView = MyDataView(sectors: myDataViewModel.sectors, profileImage: myDataViewModel.profileImage, frame: view.bounds)
        contentScrollView?.addSubview(myDataView)
        self.myDataView = myDataView
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
        contentScrollView.isPagingEnabled = true
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
        setBackgroundParallaxEffect(scrollView)
        updateProfileImageViewAlphaValue(scrollView)
        updateSectorLabelsAlphaValue(scrollView)
        updateMyWhyViewAlphaValue(scrollView)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {        
        if scrollView.contentOffset.equalTo(.zero) == true {
            contentScrollViewDelegate?.didScrollToMyData()
        } else {
            contentScrollViewDelegate?.didScrollToMyWhy()
        }
    }
}

// MARK: - ScrollView Effects

private extension MyUniverseViewController {

    func scrollFactor(_ contentScrollView: UIScrollView) -> CGFloat {
        let maxX = contentScrollView.frame.maxX - view.frame.width * 0.24
        guard maxX > 0 else {
            return 0
        }

        return 1 - (contentScrollView.contentOffset.x/maxX)
    }

    func setBackgroundParallaxEffect(_ contentScrollView: UIScrollView) {
        let backgroundContentOffset = CGPoint(x: contentScrollView.contentOffset.x * 1.2, y: contentScrollView.contentOffset.y)
        backgroundScrollView?.setContentOffset(backgroundContentOffset, animated: false)
    }

    func updateProfileImageViewAlphaValue(_ contentScrollView: UIScrollView) {
        let alpha = scrollFactor(contentScrollView)
        myDataView?.profileImageViewOverlay.alpha = alpha
        myDataView?.profileImageViewOverlayEffect.alpha = alpha
    }

    func updateSectorLabelsAlphaValue(_ contentScrollView: UIScrollView) {
        let alpha = scrollFactor(contentScrollView)
        myDataSectorLabelsView?.sectorLabels.forEach({ (sectorLabel: UILabel) in
            sectorLabel.alpha = alpha
        })
    }

    func updateMyWhyViewAlphaValue(_ contentScrollView: UIScrollView) {
        let alpha = scrollFactor(contentScrollView)
        myWhyView?.alpha = 1 - alpha
    }
}
