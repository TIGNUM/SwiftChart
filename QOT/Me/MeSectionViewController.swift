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
    let angle: CGFloat
    let load: CGFloat
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
    let profileImageWidth: CGFloat = screen.width * 0.25
    let radiusMaxLoad: CGFloat = screen.width * 0.7
    let radiusAverageLoad: CGFloat = screen.width * 0.45
    let offsetLoad: CGFloat = 12
    let offsetScrollView: CGFloat = (screen.width * 0.06)
    let loadCenter = CGPoint(x: (screen.width - (screen.width * 0.06)), y: screen.height * 0.5)

    weak var delegate: MeSectionDelegate?

    let categoryLabel: [CategoryLabel] = [
        CategoryLabel(text: "Peak", textColor: UIColor(white: 0.7, alpha: 0.6), angle: 245, load: 1.1),
        CategoryLabel(text: "Meetings", textColor: .red, angle: 220, load: 1.25),
        CategoryLabel(text: "Intensity", textColor: UIColor(white: 0.7, alpha: 0.6), angle: 195, load: 1.3),
        CategoryLabel(text: "Travel", textColor: UIColor(white: 0.7, alpha: 0.6), angle: 170, load: 1.2),
        CategoryLabel(text: "Sleep", textColor: UIColor(white: 0.7, alpha: 0.6), angle: 145, load: 1.1),
        CategoryLabel(text: "Activity", textColor: UIColor(white: 0.7, alpha: 0.6), angle: 120, load: 1.1)
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
            x: loadCenter.x - profileImageWidth * 0.5,
            y: loadCenter.y - profileImageWidth * 0.5,
            width: profileImageWidth,
            height: profileImageWidth
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
        drawBackCircles(radius: radiusAverageLoad, linesDashPattern: [2, 1])
        drawBackCircles(radius: radiusMaxLoad)
//        connectDataPoint()
//        drawDataPoints()
        addCategoryLabels()
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
        scrollView.contentSize = CGSize(
            width: (UIScreen.main.bounds.width * 2) - (offsetScrollView * 4),
            height: UIScreen.main.bounds.height - 84
        )
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

        dataPointsCenterCoordinates.insert(loadCenter, at: 0)
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
        let circlePath = UIBezierPath.circlePath(center: loadCenter, radius: radius)
        let shapeLayer = CAShapeLayer.pathWithColor(
            path: circlePath.cgPath,
            fillColor: .clear,
            strokeColor: strokeColor
        )
        shapeLayer.lineDashPattern = linesDashPattern
        view.layer.addSublayer(shapeLayer)
    }

    func drawSectors() {
        spikes.forEach { (spike: Spike) in
            var load = spike.load

            if load > 0.9 {
                load = 0.9
            }

            if load < 0.1 {
                load = 0.1
            }

            let factor: CGFloat = radiusMaxLoad
            let offset: CGFloat = ((profileImageView.frame.width * 0.5) + offsetLoad)
            let radius: CGFloat = (load * (factor - offsetLoad)) + (offset * 0.4)

            print("load: \(spike.load)")
            print("radius: \(radius)")
            print("load * \(factor) + offset: \(offset) == \((spike.load * factor) + offset)")

            let endPopint = center(with: radius, angle: spike.angle)

            drawSpike(
                to: endPopint,
                strokeColor: spike.strokeColor
            )

            placeDot(
                fillColor: radius > (radiusAverageLoad - (spike.load * 4)) ? .red : .white,
                strokeColor: radius > (radiusAverageLoad - (spike.load * 4)) ? UIColor(red: 1, green: 0, blue: 0, alpha: 0.8) : UIColor(white: 1, alpha: 0.7),
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

    func center(with radius: CGFloat, angle: CGFloat) -> CGPoint {
        let converted = angle.degreesToRadians
        let xPos = profileImageView.center.x + radius * cos(converted)
        let yPos = profileImageView.center.y + radius * sin(converted)
        return CGPoint(x: xPos, y: yPos)
    }

//    func drawSector(offset: CGFloat) {
//        let yPos = profileImageView.center.y * offset
//        print("offsett: \(yPos)")
//        print("maxY: \(UIScreen.main.bounds.maxY)")
//
//        let centerPi = CGPoint(x: 0, y: yPos)
//        let centerPiLine = CAShapeLayer.line(from: centerPi, to: profileImageView.center, strokeColor: .red)
//        view.layer.addSublayer(centerPiLine)
//    }
//
//    func connectDataPoint() {
//        for (index, center) in dataPointsCenterCoordinates.enumerated() {
//            let nextIndex = (index + 1)
//
//            guard nextIndex < dataPointsCenterCoordinates.count else {
//                return
//            }
//
//            let nextCenter = dataPointsCenterCoordinates[nextIndex]
//            let line = CAShapeLayer.line(from: center, to: nextCenter, strokeColor: strokeColor)
//            view.layer.addSublayer(line)
//        }
//    }
//
    func addCategoryLabels() {
        categoryLabel.forEach { (categoryLabel: CategoryLabel) in
            let factor: CGFloat = radiusMaxLoad
            let offset: CGFloat = ((profileImageView.frame.width * 0.5) + offsetLoad)
            let radius: CGFloat = (categoryLabel.load * (factor - offsetLoad)) + (offset * 0.4)

            let labelCenter = center(with: radius, angle: categoryLabel.angle)
            let frame = CGRect(x: labelCenter.x, y: labelCenter.y, width: 0, height: 21)
            let label = UILabel(frame: frame)
            label.text = categoryLabel.text.uppercased()
            label.textColor = categoryLabel.textColor
            label.sizeToFit()
            view.addSubview(label)
        }
    }
}
