//
//  MyToBeVisionViewController.swift
//  QOT
//
//  Created by karmic on 18.04.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Kingfisher

protocol MyToBeVisionViewControllerDelegate: class {

    func didTapClose(in viewController: MyToBeVisionViewController)
}

class MyToBeVisionViewController: UIViewController {

    // MARK: - Properties

    @IBOutlet weak var headlineLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var webView: UIWebView!
    fileprivate let viewModel: MyToBeVisionViewModel
    weak var delegate: MyToBeVisionViewControllerDelegate?

    // MARK: - Init

    init(viewModel: MyToBeVisionViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        maskImageView(imageView: imageView)
    }
}

// MARK: - Private

private extension MyToBeVisionViewController {

    func setupView() {
        setupLabels()
        configureWebView(string: viewModel.text)
        imageView.kf.setImage(with: viewModel.profileImage)
    }

    private func setupLabels() {
        headlineLabel.attributedText = NSMutableAttributedString(
            string: viewModel.headLine.uppercased(),
            letterSpacing: 2,
            font: Font.H1MainTitle,
            lineSpacing: 3.0
        )
        subtitleLabel.attributedText = NSMutableAttributedString(
            string: viewModel.subHeadline.uppercased(),
            letterSpacing: 2,
            font: Font.H7Tag,
            lineSpacing: 0
        )
    }

    func maskImageView(imageView: UIImageView) {
        let clippingBorderPath = UIBezierPath()
        clippingBorderPath.move(to: CGPoint(x: 0, y: 56))
        clippingBorderPath.addCurve(
            to: CGPoint(x: view.bounds.size.width, y: 56),
            controlPoint1: CGPoint(x: view.bounds.size.width/2 - 50, y: 5),
            controlPoint2: CGPoint(x: view.bounds.size.width/2 + 50, y: 5)
        )
        clippingBorderPath.addLine(to: CGPoint(x:  view.bounds.size.width, y: view.bounds.size.height + 15))
        clippingBorderPath.addLine(to: CGPoint(x:  0, y: view.bounds.size.height + 15))
        clippingBorderPath.close()

        let borderMask = CAShapeLayer()
        borderMask.path = clippingBorderPath.cgPath
        imageView.layer.mask = borderMask
        imageView.center = view.center
    }

    func configureWebView(string: String) {
        let text = "<html><head><link rel=\"stylesheet\" type=\"text/css\" href=\"styles.css\"></head>" + "<body style='background:none'><div class='text'>\(string)</div></body></html>"
        let mainbundle = Bundle.main.bundlePath
        let bundleURL = NSURL(fileURLWithPath: mainbundle)
        webView.loadHTMLString(text, baseURL: bundleURL as URL)
        webView.backgroundColor = UIColor.clear
        webView.isOpaque = false
        webView.scrollView.showsVerticalScrollIndicator = false
        webView.scrollView.showsHorizontalScrollIndicator = false
        webView.scrollView.bounces = false
        webView.scrollView.contentInset.right = 230
        webView.scrollView.contentInset.left = 21
        webView.scrollView.delegate = self
    }
}

// MARK: - Actions

extension MyToBeVisionViewController {

    @IBAction func closeAction(_ sender: Any) {
        delegate?.didTapClose(in: self)
    }
}

// MARK: UIScrollViewDelegate

extension MyToBeVisionViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 0 {
            scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: 0)
        }
    }
}
