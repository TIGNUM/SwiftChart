//
//  MeSectionViewController.swift
//  QOT
//
//  Created by karmic on 22/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

struct CategoryLabel {
    let text: String
    let textColor: UIColor
    let position: CGPoint
}

struct Spike {
    let strokeColor: UIColor
    let angle: CGFloat
    let load: CGFloat
}

class MeSectionViewController: UIViewController {
    
    // MARK: - Properties

    let viewModel: MeSectionViewModel
    let strokeColor = UIColor(white: 0.7, alpha: 0.4)
    var dataPointsCenterCoordinates = [CGPoint]()
    let scrollView = UIScrollView(frame: UIScreen.main.bounds)
    var profileImageView = UIImageView()

    weak var delegate: MeSectionDelegate?

    let categoryLabel: [CategoryLabel] = [
        CategoryLabel(text: "Itensity", textColor: UIColor(white: 0.7, alpha: 0.6), position: CGPoint(x: 200, y: 100)),
        CategoryLabel(text: "Meetings", textColor: .red, position: CGPoint(x: 150, y: 200)),
        CategoryLabel(text: "Peak", textColor: UIColor(white: 0.7, alpha: 0.6), position: CGPoint(x: 100, y: 300)),
        CategoryLabel(text: "Trips", textColor: UIColor(white: 0.7, alpha: 0.6), position: CGPoint(x: 50, y: 400)),
        CategoryLabel(text: "Sleep", textColor: UIColor(white: 0.7, alpha: 0.6), position: CGPoint(x: 150, y: 500)),
        CategoryLabel(text: "Activity", textColor: UIColor(white: 0.7, alpha: 0.6), position: CGPoint(x: 200, y: 600))
    ]

    let sectorPoints = [
        CGPoint(x: 0, y: 0),
        CGPoint(x: 0, y: UIScreen.main.bounds.height),
        CGPoint(x: 0, y: UIScreen.main.bounds.height * 0.5)
    ]

    let spikes = [
        Spike(strokeColor: .magenta, angle: 260, load: randomNumber),
        Spike(strokeColor: .magenta, angle: 252, load: randomNumber),
        Spike(strokeColor: .magenta, angle: 244, load: randomNumber),
        Spike(strokeColor: .blue, angle: 236, load: randomNumber),
        Spike(strokeColor: .blue, angle: 228, load: randomNumber),
        Spike(strokeColor: .blue, angle: 220, load: randomNumber),
        Spike(strokeColor: .blue, angle: 212, load: randomNumber),
        Spike(strokeColor: .blue, angle: 204, load: randomNumber),
        Spike(strokeColor: .yellow, angle: 196, load: randomNumber),
        Spike(strokeColor: .yellow, angle: 188, load: randomNumber),
        Spike(strokeColor: .yellow, angle: 180, load: randomNumber),
        Spike(strokeColor: .green, angle: 172, load: randomNumber),
        Spike(strokeColor: .green, angle: 164, load: randomNumber),
        Spike(strokeColor: .green, angle: 156, load: randomNumber),
        Spike(strokeColor: .green, angle: 148, load: randomNumber),
        Spike(strokeColor: .green, angle: 140, load: randomNumber),
        Spike(strokeColor: .orange, angle: 132, load: randomNumber),
        Spike(strokeColor: .orange, angle: 124, load: randomNumber),
        Spike(strokeColor: .cyan, angle: 116, load: randomNumber),
        Spike(strokeColor: .cyan, angle: 108, load: randomNumber),
        Spike(strokeColor: .cyan, angle: 100, load: randomNumber)
    ]

    var profileImageViewFrame: CGRect {
        return CGRect(
            x: view.frame.width - 80,
            y: (view.frame.height * 0.5) - 50,
            width: 100,
            height: 100
        )
    }

    var backgroundCircleCenterPoint: CGPoint {
        return CGPoint(
            x: profileImageViewFrame.origin.x,
            y: profileImageViewFrame.origin.x  + (profileImageViewFrame.height * 0.5) - 25
        )
    }
    
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

        view.backgroundColor = .black
        addProfileImage()
        drawBackCircles(radius: 175, linesDashPattern: [2, 1])
        drawBackCircles(radius: 250)
//        connectDataPoint()
//        drawDataPoints()
//        addCategoryLabels()
        drawSectors()
//        placeDots()
    }

    override func loadView() {
        setupScrollView()
    }
}

// MARK: - UIScrollViewDelegate

extension MeSectionViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let itensity = ((scrollView.contentOffset.x + 314) / 314)
        print("itensity: \(itensity)")
    }
}

// MARK: - Draw

private extension MeSectionViewController {

    func setupScrollView() {
        view = scrollView
        scrollView.bounces = false
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentSize = CGSize(width: (UIScreen.main.bounds.width * 2) - 100, height: UIScreen.main.bounds.height - 84)
    }

    func drawDataPoints() {
        viewModel.items.forEach { (myDataItem: MyDataItem) in
            switch myDataItem.category {
            case .load(let subCategory):
                drawDataPoint(distance: subCategory.distance, angle: subCategory.angle, category: myDataItem.category)
            case .bodyBrain(let subCategory):
                drawDataPoint(distance: subCategory.distance, angle: subCategory.angle, category: myDataItem.category)
            }
        }

        dataPointsCenterCoordinates.insert(backgroundCircleCenterPoint, at: 0)
    }

    func addProfileImage() {        
        profileImageView = UIImageView(frame: profileImageViewFrame)
        profileImageView.image = viewModel.profileImage
        profileImageView.contentMode = .scaleToFill
        profileImageView.layer.cornerRadius = profileImageView.frame.width * 0.5
        profileImageView.clipsToBounds = true
        view.addSubview(profileImageView)
    }

    func drawDataPoint(distance: CGFloat, angle: CGFloat, category: DataCategory) {
        let center = CGPoint(x: angle, y: (distance * 100))
        let circlePath = UIBezierPath.circlePath(center: center, radius: CGFloat(distance * 10))

        let shapeLayer = CAShapeLayer.pathWithColor(
            path: circlePath.cgPath,
            fillColor: .white,
            strokeColor: .white
        )
        view.layer.addSublayer(shapeLayer)
        dataPointsCenterCoordinates.append(center)
    }

    func drawBackCircles(radius: CGFloat, linesDashPattern: [NSNumber]? = nil) {
        let circlePath = UIBezierPath.circlePath(center: backgroundCircleCenterPoint, radius: radius)
        let shapeLayer = CAShapeLayer.pathWithColor(
            path: circlePath.cgPath,
            fillColor: .clear,
            strokeColor: strokeColor
        )
        shapeLayer.lineDashPattern = linesDashPattern
        view.layer.addSublayer(shapeLayer)
    }

    func drawSectors() {
//        for offset in stride(from: -3, through: 3, by: 0.25) {
//            drawSector(offset: CGFloat(offset))
//        }

        spikes.forEach { (spike: Spike) in
            let converted = spike.angle.degreesToRadians
            let x = profileImageView.center.x + ((spike.load * 160) + 80) * cos(converted)
            let y = profileImageView.center.y + ((spike.load * 160) + 80) * sin(converted)
            let endPopint = CGPoint(x: x, y: y)

            drawSpike(
                to: endPopint,
                strokeColor: spike.strokeColor
            )

            placeDot(
                fillColor: .red,
                strokeColor: UIColor(red: 1, green: 0, blue: 0, alpha: 0.8),
                center: endPopint,
                radius: (spike.load * 8)
            )
        }
    }

    func drawSpike(to point: CGPoint, strokeColor: UIColor) {
        let line = CAShapeLayer.line(from: profileImageView.center, to: point, strokeColor: strokeColor)

        view.layer.addSublayer(line)
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

    func drawSector(offset: CGFloat) {
        let yPos = profileImageView.center.y * offset
        print("offsett: \(yPos)")
        print("maxY: \(UIScreen.main.bounds.maxY)")
        let centerPi = CGPoint(x: 0, y: yPos)
        let centerPiLine = CAShapeLayer.line(from: centerPi, to: profileImageView.center, strokeColor: .red)
        view.layer.addSublayer(centerPiLine)
    }

    func connectDataPoint() {
        for (index, center) in dataPointsCenterCoordinates.enumerated() {
            let nextIndex = (index + 1)

            guard nextIndex < dataPointsCenterCoordinates.count else {
                return
            }

            let nextCenter = dataPointsCenterCoordinates[nextIndex]
            let line = CAShapeLayer.line(from: center, to: nextCenter, strokeColor: strokeColor)
            view.layer.addSublayer(line)
        }
    }

    func addCategoryLabels() {
        categoryLabel.forEach { (categoryLabel: CategoryLabel) in
            let frame = CGRect(x: categoryLabel.position.x, y: categoryLabel.position.y, width: 0, height: 21)
            let label = UILabel(frame: frame)
            label.text = categoryLabel.text
            label.textColor = categoryLabel.textColor
            label.sizeToFit()
            view.addSubview(label)
        }
    }
}
