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
    func didTapMyToBeVision(vision: Vision?, from view: UIView, in viewController: MyUniverseViewController)
    func didTapWeeklyChoices(weeklyChoice: WeeklyChoice?, from view: UIView, in viewController: MyUniverseViewController)
    func didTapQOTPartner(selectedIndex: Index, partners: [Partner], from view: UIView, in viewController: MyUniverseViewController)
}

protocol MyWhyViewDelegate: class {
    func didTapMyToBeVision(vision: Vision?, from view: UIView)
    func didTapWeeklyChoices(weeklyChoice: WeeklyChoice?, from view: UIView)
    func didTapQOTPartner(selectedIndex: Index, partners: [Partner], from view: UIView)
}

protocol ContentScrollViewDelegate: class {
    func didEndDecelerating(_ contentOffset: CGPoint)
}

final class MyUniverseViewController: UIViewController {
    
    // MARK: - Properties

    fileprivate let myDataViewModel: MyDataViewModel
    fileprivate let myWhyViewModel: MyWhyViewModel
    fileprivate var lastContentOffset: CGFloat = 0
    weak var contentScrollViewDelegate: ContentScrollViewDelegate?
    weak var delegate: MyUniverseViewControllerDelegate?

    fileprivate lazy var myDataView: MyDataView = {
        return MyDataView(
            sectors: self.myDataViewModel.sectors,
            profileImage: self.myDataViewModel.profileImage,
            frame: self.view.bounds
        )
    }()

    fileprivate lazy var myWhyView: MyWhyView = {
        let myWhyViewFrame = CGRect(
            x: self.view.bounds.width,
            y: 0,
            width: self.view.bounds.width,
            height: self.view.bounds.height
        )

        return MyWhyView(
            myWhyViewModel: self.myWhyViewModel,
            frame: myWhyViewFrame,
            screenType: self.screenType,
            delegate: self
        )
    }()

    fileprivate lazy var myDataSectorLabelsView: MyDataSectorLabelsView = {
        let myDataSectorLablesViewFrame = CGRect(
            x: 0,
            y: 0,
            width: self.view.bounds.width,
            height: self.view.bounds.height
        )

        return MyDataSectorLabelsView(
            sectors: self.myDataViewModel.sectors,
            frame: myDataSectorLablesViewFrame,
            screenType: self.screenType
        )
    }()

    fileprivate lazy var backgroundScrollView: UIScrollView = {
        let layout = Layout.MeSection(viewControllerFrame: self.view.bounds)
        let backgroundScrollView = MyUniverseHelper.createScrollView(self.view.frame, layout: layout)
        backgroundScrollView.isUserInteractionEnabled = false
        backgroundScrollView.delegate = nil

        return backgroundScrollView
    }()

    fileprivate lazy var backgroundImage: UIImageView = {
        let frame = self.view.frame
        let imageViewFrame = CGRect(
            x: frame.minX,
            y: frame.minY,
            width: frame.width * 2,
            height: frame.height
        )

        let imageView = UIImageView(frame: imageViewFrame)
        imageView.image = R.image.solarSystemBackground()

        return imageView
    }()

    lazy var contentView: UIView = {
        return self.view
    }()

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

        addTabRecognizer()
    }
}

// MARK: - ContentScrollView / SubView adding

extension MyUniverseViewController {

    func scrollView() -> UIScrollView {
        let layout = Layout.MeSection(viewControllerFrame: self.view.bounds)
        let contentScrollView = MyUniverseHelper.createScrollView(self.view.frame, layout: layout)
        contentScrollView.delegate = self
        contentScrollView.isPagingEnabled = true

        return contentScrollView
    }

    func addSubViews(contentScrollView: UIScrollView) {
        backgroundScrollView.addSubview(backgroundImage)
        view.addSubview(backgroundScrollView)
        view.addSubview(contentScrollView)
        contentScrollView.addSubview(myWhyView)
        contentScrollView.addSubview(myDataSectorLabelsView)
        contentScrollView.addSubview(myDataView)
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
        let yPosShifted = location.y - myDataView.profileImageView.center.y
        let xPosShifted = location.x - myDataView.profileImageView.center.x
        let beta = acos(xPosShifted / radius)
        let sectorAngle = beta.radiansToDegrees

        for sector in myDataViewModel.sectors {
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
        let diffX = pow(location.x - myDataView.profileImageView.center.x, 2)
        let diffY = pow(location.y - myDataView.profileImageView.center.y, 2)
        
        return sqrt(diffX + diffY)
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
        contentScrollViewDelegate?.didEndDecelerating(scrollView.contentOffset)
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
        backgroundScrollView.setContentOffset(backgroundContentOffset, animated: false)
    }

    func updateProfileImageViewAlphaValue(_ contentScrollView: UIScrollView) {
        let alpha = scrollFactor(contentScrollView)
        myDataView.profileImageViewOverlay.alpha = alpha
        myDataView.profileImageViewOverlayEffect.alpha = alpha
    }

    func updateSectorLabelsAlphaValue(_ contentScrollView: UIScrollView) {
        let alpha = scrollFactor(contentScrollView)
        myDataSectorLabelsView.sectorLabels.forEach({ (sectorLabel: UILabel) in
            sectorLabel.alpha = alpha
        })
    }

    func updateMyWhyViewAlphaValue(_ contentScrollView: UIScrollView) {
        let alpha = scrollFactor(contentScrollView)
        myWhyView.alpha = 1 - alpha
    }
}

extension MyUniverseViewController: MyWhyViewDelegate {

    func didTapMyToBeVision(vision: Vision?, from view: UIView) {
        delegate?.didTapMyToBeVision(vision: vision, from: view, in: self)
    }

    func didTapWeeklyChoices(weeklyChoice: WeeklyChoice?, from view: UIView) {
        delegate?.didTapWeeklyChoices(weeklyChoice: weeklyChoice, from: view, in: self)
    }

    func didTapQOTPartner(selectedIndex: Index, partners: [Partner], from view: UIView) {
        delegate?.didTapQOTPartner(selectedIndex: selectedIndex, partners: partners, from: view, in: self)
    }
}
