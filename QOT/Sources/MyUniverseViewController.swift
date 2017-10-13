//
//  MyUniverseViewController.swift
//  QOT
//
//  Created by karmic on 22/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import ReactiveKit

protocol MyUniverseViewControllerDelegate: class {

    func didTapSector(startingSection: StatisticsSectionType?, in viewController: MyUniverseViewController)

    func didTapMyToBeVision(vision: MyToBeVision?, from view: UIView, in viewController: MyUniverseViewController)

    func didTapWeeklyChoices(weeklyChoice: WeeklyChoice?, from view: UIView, in viewController: MyUniverseViewController)

    func didTapQOTPartner(selectedIndex: Index, partners: [Partner], from view: UIView, in viewController: MyUniverseViewController)

    func didTapRightBarButton(_ button: UIBarButtonItem, from topNavigationBar: TopNavigationBar, in viewController: MyUniverseViewController)
}

protocol MyWhyViewDelegate: class {

    func didTapMyToBeVision(vision: MyToBeVision?, from view: UIView)

    func didTapWeeklyChoices(weeklyChoice: WeeklyChoice?, from view: UIView)

    func didTapQOTPartner(selectedIndex: Index, partners: [Partner], from view: UIView)
}

final class MyUniverseViewController: UIViewController {
    
    // MARK: - Properties

    fileprivate let disposeBag = DisposeBag()
    fileprivate let myDataViewModel: MyDataViewModel
    fileprivate let myWhyViewModel: MyWhyViewModel
    fileprivate var lastContentOffset: CGFloat = 0
    var pageName: PageName = .myData
    weak var delegate: MyUniverseViewControllerDelegate?
    let pageTracker: PageTracker

    fileprivate lazy var topBar: TopNavigationBar = {
        let topBar = TopNavigationBar(frame: CGRect(
            x: 0.0,
            y: 20.0,
            width: self.view.bounds.size.width,
            height: 44.0
        ))
        topBar.items = [UINavigationItem()]
        topBar.topNavigationBarDelegate = self
        let rightButton = UIBarButtonItem(withImage: R.image.ic_menu())
        topBar.setRightButton(rightButton)
        topBar.setMiddleButtons(self.middleButtons)

        return topBar
    }()
    
    fileprivate lazy var middleButtons: [UIButton] = {
        let myDataButton = UIButton(type: .custom)
        myDataButton.setTitle(R.string.localized.topTabBarItemTitleMeMyData().uppercased(), for: .normal)
        myDataButton.setTitleColor(.white, for: .normal)
        myDataButton.titleLabel?.font = Font.H5SecondaryHeadline
        myDataButton.backgroundColor = .clear
        
        let myWhyButton = UIButton(type: .custom)
        myWhyButton.setTitle(R.string.localized.topTabBarItemTitleMeMyWhy().uppercased(), for: .normal)
        myWhyButton.setTitleColor(.white, for: .normal)
        myWhyButton.titleLabel?.font = Font.H5SecondaryHeadline
        myWhyButton.backgroundColor = .clear
        
        return [myDataButton, myWhyButton]
    }()
    
    fileprivate lazy var myDataView: MyDataView = {
        return MyDataView(
            delegate: self,
            sectors: self.myDataViewModel.sectors,
            myDataViewModel: self.myDataViewModel,
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
    
    fileprivate lazy var scrollView: UIScrollView = {
        let layout = Layout.MeSection(viewControllerFrame: self.view.bounds)
        let contentScrollView = MyUniverseHelper.createScrollView(self.view.bounds, layout: layout)
        contentScrollView.delegate = self
        contentScrollView.isPagingEnabled = true
        contentScrollView.contentInset = UIEdgeInsets(
            top: self.topBar.bounds.size.height + 20.0,
            left: contentScrollView.contentInset.left,
            bottom: contentScrollView.contentInset.bottom,
            right: contentScrollView.contentInset.right
        )

        return contentScrollView
    }()

    fileprivate lazy var backgroundScrollView: UIScrollView = {
        let layout = Layout.MeSection(viewControllerFrame: self.view.bounds)
        let backgroundScrollView = MyUniverseHelper.createScrollView(self.view.frame, layout: layout)
        backgroundScrollView.isUserInteractionEnabled = false
        backgroundScrollView.delegate = nil

        return backgroundScrollView
    }()

    fileprivate lazy var backgroundImage: UIView = {
        let frame = self.view.frame
        let imageViewFrame = CGRect(x: frame.minX, y: frame.minY, width: frame.width * 2, height: frame.height)
        let imageView = UIImageView(frame: imageViewFrame)
        imageView.image = R.image.backgroundMyUniverse()
        imageView.contentMode = .scaleAspectFill

        return imageView
    }()

    // MARK: - Life Cycle

    init(myDataViewModel: MyDataViewModel, myWhyViewModel: MyWhyViewModel, pageTracker: PageTracker) {
        self.myDataViewModel = myDataViewModel
        self.myWhyViewModel = myWhyViewModel
        self.pageTracker = pageTracker

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        addTabRecognizer()
        addSubViews()

        myWhyViewModel.updates.observeNext { [weak self, weak myWhyViewModel] (_: CollectionUpdate) in
            if let resource = myWhyViewModel?.myToBeVision?.profileImageResource {
                self?.myDataView.updateProfileImageResource(resource)
            }
        }.dispose(in: disposeBag)
    }
}

// MARK: - Private

private extension MyUniverseViewController {

    func addSubViews() {
        backgroundScrollView.addSubview(backgroundImage)
        view.addSubview(backgroundScrollView)
        view.addSubview(scrollView)
        view.addSubview(topBar)
        scrollView.addSubview(myWhyView)
        scrollView.addSubview(myDataSectorLabelsView)
        scrollView.addSubview(myDataView)
    }
    
    func updatePageTracking() {
        switch pageIndex {
        case 0: pageName = .myData
        default: pageName = .myWhy
        }

        pageTracker.track(self)
    }
}

// MARK: - TabRecognizer

private extension MyUniverseViewController {

    func addTabRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapSector))
        scrollView.addGestureRecognizer(tapGestureRecognizer)
    }

    @objc func didTapSector(recognizer: UITapGestureRecognizer) {
        guard pageIndex == 0 else {
            return
        }
        delegate?.didTapSector(startingSection: section(location: recognizer.location(in: view)), in: self)
    }
}

// MARK: - TabRecognizer Helper

private extension MyUniverseViewController {

    func section(location: CGPoint) -> StatisticsSectionType? {
        let radius = lengthFromCenter(for: location)
        let yPosShifted = location.y - myDataView.profileImageButton.center.y
        let xPosShifted = location.x - myDataView.profileImageButton.center.x
        let beta = acos(xPosShifted / radius)
        let sectorAngle = beta.radiansToDegrees

        for sector in myDataViewModel.sectors {
            if yPosShifted >= 0 {
                if sector.startAngle ... sector.endAngle ~= sectorAngle {
                    return sectionType(for: sector.labelType)
                }

                if sectorAngle < 119 {
                    guard let type = myDataViewModel.sectors.last?.labelType else {
                        return nil
                    }

                    return sectionType(for: type)
                }
            } else {
                let mappedSectorAngle = 180 + (180 - sectorAngle)
                if sector.startAngle ... sector.endAngle ~= mappedSectorAngle {
                    return sectionType(for: sector.labelType)
                }

                if sectorAngle < 100 {
                    guard let type = myDataViewModel.sectors.first?.labelType else {
                        return nil
                    }

                    return sectionType(for: type)
                }
            }
        }

        return nil
    }

    func sectionType(for type: SectorLabelType) -> StatisticsSectionType {
        switch type {
        case .activity: return .activity
        case .intensity: return .intensity
        case .meetings: return .meetings
        case .peak: return .peakPerformance
        case .sleep: return .sleep
        case .travel: return .travel
        }
    }

    func lengthFromCenter(for location: CGPoint) -> CGFloat {
        let diffX = pow(location.x - myDataView.profileImageButton.center.x, 2)
        let diffY = pow(location.y - myDataView.profileImageButton.center.y, 2)
        
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
        updatePageTracking()
        guard scrollView.contentOffset.x > 0.0 else {
            topBar.setIndicatorToButtonIndex(0)
            return
        }
        
        topBar.setIndicatorToButtonIndex(pageIndex)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        updatePageTracking()
    }
    
    var pageIndex: Int {
        guard scrollView.contentOffset.x > 0.0 else {
            return 0
        }
        return Int(floor(scrollView.frame.size.width / scrollView.contentOffset.x))
    }
    
    func pageOffsetForIndex(_ index: Int) -> CGFloat {
        switch index {
        case 1:
            // @warning hacky - but not sure how else to handle this. returning myDataView.width, or myWhyView.x doesnt work - the page offset is too large
            return scrollView.contentSize.width - view.bounds.size.width
        default:
            return 0.0
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

// MARK: - MyWhyViewDelegate

extension MyUniverseViewController: MyWhyViewDelegate {

    func didTapMyToBeVision(vision: MyToBeVision?, from view: UIView) {
        delegate?.didTapMyToBeVision(vision: vision, from: view, in: self)
    }

    func didTapWeeklyChoices(weeklyChoice: WeeklyChoice?, from view: UIView) {
        delegate?.didTapWeeklyChoices(weeklyChoice: weeklyChoice, from: view, in: self)
    }

    func didTapQOTPartner(selectedIndex: Index, partners: [Partner], from view: UIView) {
        delegate?.didTapQOTPartner(selectedIndex: selectedIndex, partners: partners, from: view, in: self)
    }
}

extension MyUniverseViewController: MyDataViewDelegate {

    func myDataView(_ view: MyDataView, pressedProfileButton button: UIButton) {
        delegate?.didTapMyToBeVision(vision: myWhyViewModel.myToBeVision, from: button, in: self)
    }
}

// MARK: - CustomPresentationAnimatorDelegate {

extension MyUniverseViewController: CustomPresentationAnimatorDelegate {

    func animationsForAnimator(_ animator: CustomPresentationAnimator) -> (() -> Void)? {
        if animator.toViewController is MyToBeVisionViewController {
            return { [unowned self] in
                self.myDataView.profileImageButton.transform = CGAffineTransform(translationX: 90.0, y: 260.0).scaledBy(x: 4.0, y: 3.0)
                self.myWhyView.myToBeVisionBox.transform = CGAffineTransform(translationX: -120.0, y: 20.0)
                self.myWhyView.weeklyChoicesBox.transform = CGAffineTransform(translationX: 100.0, y: 10.0)
                self.myWhyView.qotPartnersBox.transform = CGAffineTransform(translationX: 10.0, y: 100.0)
            }
        } else if animator.fromViewController is MyToBeVisionViewController {
            return { [unowned self] in
                self.myDataView.profileImageButton.transform = .identity
                self.myWhyView.myToBeVisionBox.transform = .identity
                self.myWhyView.weeklyChoicesBox.transform = .identity
                self.myWhyView.qotPartnersBox.transform = .identity
            }
        } else if let toViewController = animator.toViewController, toViewController.contains(PartnersViewController.self) {
            return { [unowned self] in
                self.myWhyView.qotPartnersBox.transform = CGAffineTransform(translationX: 200.0, y: -300.0).scaledBy(x: 2.5, y: 2.5)
            }
        } else if let fromViewController = animator.fromViewController, fromViewController.contains(PartnersViewController.self) {
            return { [unowned self] in
                self.myWhyView.qotPartnersBox.transform = .identity
            }
        } else if let toViewController = animator.toViewController, toViewController.contains(ChartViewController.self) {
            self.parent?.view.alpha = 1

            return { [unowned self] in
                self.parent?.view.alpha = 0

                self.myDataView.profileImageButton.transform = CGAffineTransform(translationX: 300.0, y: 0)
                self.view.transform = CGAffineTransform(scaleX: 3, y: 3)//.translatedBy(x: -180, y: 0)

                let layerTransform = self.myDataView.universeDotsLayer.transform
                self.myDataView.universeDotsLayer.transform = CATransform3DTranslate(layerTransform, -200, 0, 0)
            }
        } else if let fromViewController = animator.fromViewController, fromViewController.contains(ChartViewController.self) {
            self.parent?.view.alpha = 0

            let layerTransform = self.myDataView.universeDotsLayer.transform
            self.myDataView.universeDotsLayer.transform = CATransform3DTranslate(layerTransform, -200, 0, 0)

            return { [unowned self] in
                self.parent?.view.alpha = 1

                self.myDataView.profileImageButton.transform = .identity
                self.view.transform = .identity

                self.myDataView.universeDotsLayer.transform = CATransform3DIdentity
            }
        } else if let toViewController = animator.toViewController, toViewController.contains(WeeklyChoicesViewController.self) {
            self.myWhyView.weeklyChoicesBox.alpha = 1
            return { [unowned self] in
                self.myWhyView.weeklyChoicesBox.alpha = 0
                self.myWhyView.myToBeVisionBox.transform = CGAffineTransform(translationX: -120.0, y: -50.0)
                self.myWhyView.weeklyChoicesBox.transform = CGAffineTransform(translationX: 100.0, y: 10.0)
                self.myWhyView.qotPartnersBox.transform = CGAffineTransform(translationX: -120.0, y: -50.0)

                self.view.transform = CGAffineTransform(translationX: -580.0, y: -50.0).scaledBy(x: 4.0, y: 3.0)
            }
        } else if let fromViewController = animator.fromViewController, fromViewController.contains(WeeklyChoicesViewController.self) {
            self.myWhyView.weeklyChoicesBox.alpha = 0
            return { [unowned self] in
                self.myWhyView.weeklyChoicesBox.alpha = 1
                self.myWhyView.myToBeVisionBox.transform = .identity
                self.myWhyView.weeklyChoicesBox.transform = .identity
                self.myWhyView.qotPartnersBox.transform = .identity

                self.view.transform = .identity
            }
        } else if let toViewController = animator.toViewController, toViewController.contains(PartnersViewController.self) {
            return { [unowned self] in
                self.myWhyView.qotPartnersBox.transform = CGAffineTransform(translationX: 200.0, y: -300.0).scaledBy(x: 2.5, y: 2.5)
            }
        } else if let fromViewController = animator.fromViewController, fromViewController.contains(PartnersViewController.self) {
            return { [unowned self] in
                self.myWhyView.qotPartnersBox.transform = .identity
            }
        }
        return nil
    }
}

// MARK: - TopNavigationBarDelegate

extension MyUniverseViewController: TopNavigationBarDelegate {
    func topNavigationBar(_ navigationBar: TopNavigationBar, leftButtonPressed button: UIBarButtonItem) {
    }
    
    func topNavigationBar(_ navigationBar: TopNavigationBar, middleButtonPressed button: UIButton, withIndex index: Int, ofTotal total: Int) {
        guard let index = middleButtons.index(of: button) else {
            return
        }
        scrollView.setContentOffset(CGPoint(
            x: pageOffsetForIndex(index),
            y: scrollView.contentOffset.y
        ), animated: true)
    }
    
    func topNavigationBar(_ navigationBar: TopNavigationBar, rightButtonPressed button: UIBarButtonItem) {
        delegate?.didTapRightBarButton(button, from: navigationBar, in: self)
    }
}

// MARK: - animation helper

private extension UIViewController {

    func contains(_ classId: AnyClass) -> Bool {
        if let navigationController = self as? UINavigationController, let pageViewController = navigationController.viewControllers.first as? PageViewController, let viewController = pageViewController.data?.first, viewController.classForCoder == classId {
            return true
        }
        return false
    }
}
