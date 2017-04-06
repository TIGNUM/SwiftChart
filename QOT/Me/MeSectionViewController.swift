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

class MeSectionViewController: UIViewController {
    
    // MARK: - Properties

    let viewModel: MeSectionViewModel
    let strokeColor = UIColor(white: 0.7, alpha: 0.4)
    var dataPointsCenterCoordinates = [CGPoint]()
    let scrollView = UIScrollView(frame: UIScreen.main.bounds)

    weak var delegate: MeSectionDelegate?

    let categoryLabel: [CategoryLabel] = [
        CategoryLabel(text: "Load", textColor: UIColor(white: 0.7, alpha: 0.6), position: CGPoint(x: 200, y: 100)),
        CategoryLabel(text: "Meetings", textColor: .red, position: CGPoint(x: 150, y: 200)),
        CategoryLabel(text: "Peak", textColor: UIColor(white: 0.7, alpha: 0.6), position: CGPoint(x: 100, y: 300)),
        CategoryLabel(text: "Trips", textColor: UIColor(white: 0.7, alpha: 0.6), position: CGPoint(x: 50, y: 400)),
        CategoryLabel(text: "Sleep", textColor: UIColor(white: 0.7, alpha: 0.6), position: CGPoint(x: 150, y: 500)),
        CategoryLabel(text: "Activity", textColor: UIColor(white: 0.7, alpha: 0.6), position: CGPoint(x: 200, y: 600))
    ]

    var profileImageFrame: CGRect {
        return CGRect(
            x: view.frame.width - 80,
            y: view.frame.height * 0.5,
            width: 100,
            height: 100
        )
    }

    var backgroundCircleCenterPoint: CGPoint {
        return CGPoint(
            x: profileImageFrame.origin.x,
            y: profileImageFrame.origin.x + (profileImageFrame.height * 0.5)
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

        let scrollView = UIScrollView(frame: UIScreen.main.bounds)

        view.addSubview(scrollView)
        view.backgroundColor = .black
    }

    override func loadView() {
        // calling self.view later on will return a UIView!, but we can simply call
        // self.scrollView to adjust properties of the scroll view:
        view = scrollView

        // setup the scroll view
        let screenFrame = UIScreen.main.bounds        
        scrollView.contentSize = CGSize(width: (screenFrame.width * 2), height: screenFrame.height - 84)
        // etc...
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        drawBackCircles(radius: 175, linesDashPattern: [2, 1])
        drawBackCircles(radius: 250)
        connectDataPoint()
        drawDataPoints()
        addCategoryLabels()
    }

    private func drawDataPoints() {
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

    private func addProfileImage(placeholderURL: URL) {
        let imageView = UIImageView(frame: profileImageFrame)
        imageView.image = R.image.profileImage()
        imageView.layer.cornerRadius = imageView.frame.width * 0.5
        imageView.clipsToBounds = true
        view.addSubview(imageView)
    }

    private func drawDataPoint(distance: CGFloat, angle: CGFloat, category: DataCategory) {
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

    private func drawBackCircles(radius: CGFloat, linesDashPattern: [NSNumber]? = nil) {
        let circlePath = UIBezierPath.circlePath(center: backgroundCircleCenterPoint, radius: radius)
        let shapeLayer = CAShapeLayer.pathWithColor(
            path: circlePath.cgPath,
            fillColor: .clear,
            strokeColor: strokeColor
        )
        shapeLayer.lineDashPattern = linesDashPattern
        view.layer.addSublayer(shapeLayer)
    }

    private func connectDataPoint() {
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

    private func addCategoryLabels() {
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
