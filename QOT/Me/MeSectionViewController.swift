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

    let viewModel: MeSectionViewModel
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

        view.backgroundColor = .black
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        drawDataPoints()
    }

    private func drawDataPoints() {
        viewModel.items.forEach { (myDataItem: MyDataItem) in
            switch myDataItem {
            case .dataPoint(_, _, let distance, let angle, let category):
                drawDataPoint(distance: distance, angle: angle, category: category)
            case .image(_, let placeholderURL):
                drawProfileImage(placeholderURL: placeholderURL)
            }
        }
    }

    private func drawProfileImage(placeholderURL: URL) {
        let frame = CGRect(x: view.frame.size.width - 80, y: view.frame.size.height * 0.5, width: 100, height: 100)
        let imageView = UIImageView(frame: frame)
        imageView.image = R.image.profileImage()
        imageView.layer.cornerRadius = imageView.frame.width * 0.5
        imageView.clipsToBounds = true
        view.addSubview(imageView)
    }

    private func drawDataPoint(distance: CGFloat, angle: CGFloat, category: MyDataItem.Category) {
        let circlePath = UIBezierPath(
            arcCenter: CGPoint(x: (angle * 100) + (randomNumber * 100), y: (distance * 100) + (randomNumber * 300)),
            radius: CGFloat(distance * 10),
            startAngle: CGFloat(0),
            endAngle:CGFloat(Double.pi * 2),
            clockwise: true
        )

        let dataPointColor: UIColor

        switch category {
        case .load: dataPointColor = .red
        case .brainBody: dataPointColor = .white
        }

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath

        shapeLayer.fillColor = dataPointColor.cgColor
        shapeLayer.strokeColor = dataPointColor.cgColor
        shapeLayer.lineWidth = 1.0
        view.layer.addSublayer(shapeLayer)
    }

//    private func connectDataPoint() {
//        var aPath = UIBezierPath()
//        aPath.moveToPoint(CGPoint(x:/*Put starting Location*/, y:/*Put starting Location*/))
//        aPath.addLineToPoint(CGPoint(x:/*Put Next Location*/, y:/*Put Next Location*/))
//
//        //Keep using the method addLineToPoint until you get to the one where about to close the path
//
//        aPath.closePath()
//
//        //If you want to stroke it with a red color
//        UIColor.redColor().set()
//        aPath.stroke()
//        //If you want to fill it as well
//        aPath.fill()
//    }
}
