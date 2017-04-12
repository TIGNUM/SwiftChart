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
    fileprivate var scrollView: UIScrollView?
    fileprivate var solarView: MeSolarView?
    weak var delegate: MeSectionViewControllerDelegate?

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

        addSubViews()
        addTabRecognizer()
    }
}

// MARK: - TabRecognizer

private extension MeSectionViewController {

    func addTabRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapSector))
        view?.addGestureRecognizer(tapGestureRecognizer)
    }

    @objc func didTapSector(recognizer: UITapGestureRecognizer) {
        delegate?.didTapSector(sector: sector(location: recognizer.location(in: view)), in: self)
    }
}

// MARK: - Helpers

private extension MeSectionViewController {

    func addSubViews() {
        setupScrollView(layout: Layout.MeSection(viewControllerFrame: view.bounds))
        let solarView = MeSolarView(sectors: viewModel.sectors, profileImage: viewModel.profileImage, frame: view.bounds)
        scrollView?.addSubview(solarView)
        self.solarView = solarView
    }

    func sector(location: CGPoint) -> Sector? {
        let radius = lengthFromCenter(for: location)
        let yPosShifted = location.y - (solarView?.profileImageView.center.y ?? 0)
        let xPosShifted = location.x - (solarView?.profileImageView.center.x ?? 0)
        let beta = acos(xPosShifted / radius)
        let sectorAngle = beta.radiansToDegrees

        for (_, sector) in viewModel.sectors.enumerated() {
            if yPosShifted >= 0 {
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

// MARK: - ScrollView

private extension MeSectionViewController {

    func setupScrollView(layout: Layout.MeSection) {
        let scrollView = UIScrollView(frame: view.frame)
        scrollView.bounces = false
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentSize = CGSize(
            width: (view.frame.width * 2) - (layout.scrollViewOffset * 4),
            height: view.frame.height - 84 // TODO: Change it when the tabBar is all setup corectly with bottomLayout.
        )

        addBackgroundImage(scrollView: scrollView)
        view.addSubview(scrollView)
        self.scrollView = scrollView
    }

    func addBackgroundImage(scrollView: UIScrollView) {
        let frame = CGRect(x: view.frame.minX, y: view.frame.minY, width: view.frame.width * 2, height: view.frame.height)
        let imageView = UIImageView(frame: frame)
        imageView.image = R.image.solarSystemBackground()
        scrollView.addSubview(imageView)
    }
}
