//
//  MeSectionViewController.swift
//  QOT
//
//  Created by karmic on 22/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

protocol MeSectionViewControllerDelegate: class {
    func didTapSector(sector: Sector?, in viewController: UIViewController)
}

final class MeSectionViewController: UIViewController {
    
    // MARK: - Properties

    fileprivate let viewModel: MeSectionViewModel
    fileprivate var layout = Layout.MeSection(viewControllerFrame: .zero)
    fileprivate var scrollView: UIScrollView?
    weak var delegate: MeSectionViewControllerDelegate?
    fileprivate var solarView: MeSolarView?

    // MARK: - Life Cycle

    init(viewModel: MeSectionViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        addTabRecognizer()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        cleanUp()
        layout = Layout.MeSection(viewControllerFrame: view.frame)
        let solarView = MeSolarView()

        solarView.drawUniverse(
            in: view.bounds,
            with: viewModel.sectors,
            profileImage: viewModel.profileImage,
            layout: layout
        )


        setupScrollView()
        scrollView?.addSubview(solarView)
        self.solarView = solarView
    }

    private func cleanUp() {
        removeSubViews(for: scrollView)
        removeSubViews(for: solarView)
        scrollView?.removeFromSuperview()
        solarView?.removeFromSuperview()
        scrollView = nil
        solarView = nil
    }

    private func removeSubViews(for view: UIView?) {
        scrollView?.subviews.forEach({ (subView: UIView) in
            subView.removeFromSuperview()
        })
    }

    private func addTabRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapSector))
        scrollView?.addGestureRecognizer(tapGestureRecognizer)
    }

    func didTapSector(recognizer: UITapGestureRecognizer) {
        delegate?.didTapSector(sector: sector(location: recognizer.location(in: view)), in: self)
    }

    func sector(location: CGPoint) -> Sector? {
        let radius = lengthFromCenter(for: location)
        let yn = location.y - (solarView?.profileImageView.center.y ?? 0)
        let xn = location.x - (solarView?.profileImageView.center.x ?? 0)
        let beta = acos(xn / radius)
        let sectorAngle = beta.radiansToDegrees

        for (_, sector) in viewModel.sectors.enumerated() {
            if yn >= 0 {
                if sector.startAngle ... sector.endAngle ~= sectorAngle {
                    return sector
                }

                if sectorAngle < 100 {
                    return viewModel.sectors.last
                }
            } else {
                let mappedSectorAngle = 180 + (180 - sectorAngle)
                if sector.startAngle ... sector.endAngle ~= mappedSectorAngle {
                    return sector
                }

                if sectorAngle < 100 {
                    return viewModel.sectors.first
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

// MARK: - Draw

private extension MeSectionViewController {

    func setupScrollView() {
        scrollView = UIScrollView(frame: view.frame)
        scrollView?.bounces = false
        scrollView?.isPagingEnabled = true
        scrollView?.showsVerticalScrollIndicator = false
        scrollView?.showsHorizontalScrollIndicator = false
        scrollView?.contentSize = CGSize(
            width: (view.frame.width * 2) - (layout.scrollViewOffset * 4),
            height: view.frame.height - 84 // TODO: Change it when the tabBar is all setup corectly with bottomLayout.
        )
        
        if let scrollView = scrollView {
            view.addSubview(scrollView)
        }
    }
}
