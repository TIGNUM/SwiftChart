//
//  MeSectionViewController.swift
//  QOT
//
//  Created by karmic on 22/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

class MeSectionViewController: UIViewController {
    
    // MARK: - Properties

    fileprivate let viewModel: MeSectionViewModel
    fileprivate let strokeColor = UIColor(white: 1, alpha: 0.2)
    fileprivate var dataCenterPoints = [CGPoint]()
    fileprivate var connectionCenterPpoitns = [CGPoint]()
    fileprivate let scrollView = UIScrollView(frame: screen)
    fileprivate var profileImageView = UIImageView()
    weak var delegate: MeSectionDelegate?

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

        setupScrollView()
        view.backgroundColor = .black
        drawBackCircles(radius: Layout.MeSection.radiusAverageLoad, linesDashPattern: [2, 1])
        drawBackCircles(radius: Layout.MeSection.radiusMaxLoad)
        setupProfileImage()
        addCategoryLabels()
        collectCenterPoints()
        connectDataPoint()
        placeDots()
        view.addSubview(profileImageView)
    }
}

// MARK: - Draw

private extension MeSectionViewController {

    func setupScrollView() {
        view = scrollView
        scrollView.bounces = false
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentSize = CGSize(
            width: (screen.width * 2) - (Layout.MeSection.scrollViewOffset * 4),
            height: screen.height - 84 // TODO: Change it when the tabBar is all setup corectly with bottomLayout.
        )
    }

    func setupProfileImage() {
        profileImageView = UIImageView(frame: Layout.MeSection.profileImageViewFrame)
        profileImageView.image = viewModel.profileImage
        profileImageView.contentMode = .scaleToFill
        profileImageView.layer.cornerRadius = Layout.MeSection.profileImageWidth * 0.5
        profileImageView.clipsToBounds = true
    }

    func drawBackCircles(radius: CGFloat, linesDashPattern: [NSNumber]? = nil) {
        let circlePath = UIBezierPath.circlePath(center: Layout.MeSection.loadCenter, radius: radius)
        let shapeLayer = CAShapeLayer.pathWithColor(
            path: circlePath.cgPath,
            fillColor: .clear,
            strokeColor: strokeColor
        )
        shapeLayer.lineDashPattern = linesDashPattern
        view.layer.addSublayer(shapeLayer)
    }

    func collectCenterPoints() {
        viewModel.items.forEach { (spike: Spike) in
            let centerPoint = CGPoint.centerPoint(
                with: viewModel.radius(for: spike.spikeLoad()),
                angle: spike.angle,
                relativeCenter: profileImageView.center
            )

            dataCenterPoints.append(centerPoint)
            connectionCenterPpoitns.append(centerPoint)
        }
    }

    func placeDots() {
        for (index, center) in dataCenterPoints.enumerated() {
            let spike = viewModel.items[index]
            let radius = viewModel.radius(for: spike.spikeLoad())

            placeDot(
                fillColor: viewModel.fillColor(radius: radius, load: spike.spikeLoad()),
                strokeColor: viewModel.strokeColor(radius: radius, load: spike.spikeLoad()),
                center: center,
                radius: (spike.load * 8)
            )
        }
    }

    func placeDot(fillColor: UIColor, strokeColor: UIColor, center: CGPoint, radius: CGFloat) {
        let circlePath = UIBezierPath.circlePath(center: center, radius: radius)
        let shapeLayer = CAShapeLayer.pathWithColor(
            path: circlePath.cgPath,
            fillColor: fillColor,
            strokeColor: strokeColor
        )

        shapeLayer.lineWidth = radius * 2
        view.layer.addSublayer(shapeLayer)
    }

    func connectDataPoint() {
        addAditionalConnectionPoints()

        for (index, center) in connectionCenterPpoitns.shuffled().enumerated() {
            let nextIndex = (index + 1)
            guard nextIndex < connectionCenterPpoitns.count else {
                return
            }

            let nextCenter = connectionCenterPpoitns[nextIndex]
            let line = CAShapeLayer.line(from: center, to: nextCenter, strokeColor: strokeColor)
            view.layer.addSublayer(line)
        }
    }

    func addAditionalConnectionPoints() {
        for index in stride(from: 0, to: viewModel.itemCount, by: 5) {
            let centerPoint = dataCenterPoints[index]
            connectionCenterPpoitns.append(centerPoint)
            connectionCenterPpoitns.append(Layout.MeSection.connectionCenter)
        }
    }

    func addCategoryLabels() {
        CategoryLabel.allLabels.forEach { (categoryLabel: CategoryLabel) in
            let labelCenter = CGPoint.centerPoint(
                with: viewModel.radius(for: categoryLabel.load),
                angle: categoryLabel.angle,
                relativeCenter: profileImageView.center
            )

            let frame = CGRect(x: labelCenter.x, y: labelCenter.y, width: 0, height: Layout.MeSection.labelHeight)
            let label = UILabel(frame: frame)
            label.text = categoryLabel.text.uppercased()
            label.textColor = categoryLabel.textColor
            label.sizeToFit()
            view.addSubview(label)
        }
    }
}
