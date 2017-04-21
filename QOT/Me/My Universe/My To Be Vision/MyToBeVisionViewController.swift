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

class MyToBeVisionViewController: UIViewController, UIWebViewDelegate, UIScrollViewDelegate {

    // MARK: - Properties

    @IBOutlet weak var viewTitle: UILabel!
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

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }


    private func setupView() {

        configureWebView(string: viewModel.text)

        viewTitle.attributedText = prepareAndSetTextAttributes(string: viewModel.title.uppercased(), letterSpacing: 1, font: UIFont(name:"Simple-Regular", size: 16.0), lineSpacing: 0)
        headlineLabel.attributedText = prepareAndSetTextAttributes(string: viewModel.headLine.uppercased(), letterSpacing: 2, font: UIFont(name:"Simple-Regular", size: 36.0), lineSpacing: 3.0)
        subtitleLabel.attributedText = prepareAndSetTextAttributes(string: viewModel.subHeadline.uppercased(), letterSpacing: 2, font: UIFont(name:"BentonSans", size: 11.0), lineSpacing: 0)

        imageView.kf.setImage(with: viewModel.profileImage) { [weak self] (image, _, _, _) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.maskImageView(image: strongSelf.imageView)
        }
    }

    func maskImageView(image: UIImageView) {

        let bounds = image.bounds
        let clippingBorderPath = UIBezierPath()
        clippingBorderPath.move(to: CGPoint(x: 0, y: 56))
        clippingBorderPath.addCurve(to: CGPoint(x: bounds.size.width, y: 56),
                                    controlPoint1: CGPoint(x: bounds.size.width/2-50, y: 5),
                                    controlPoint2: CGPoint(x: bounds.size.width/2+50, y: 5))
        clippingBorderPath.addLine(to: CGPoint(x:  bounds.size.width, y: bounds.size.height+15))
        clippingBorderPath.addLine(to: CGPoint(x:  0, y: bounds.size.height+15))
        clippingBorderPath.close()

        let borderMask = CAShapeLayer()
        borderMask.path = clippingBorderPath.cgPath
        image.layer.mask = borderMask

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
        webView.scrollView.contentInset.right = 170
        webView.scrollView.contentInset.left = 21
        webView.scrollView.delegate = self

    }

    func prepareAndSetTextAttributes(string: String, letterSpacing: CGFloat, font: UIFont?, lineSpacing: CGFloat) -> NSMutableAttributedString {
        let defaultFont: UIFont = UIFont(name:"Simple-Regular", size: 14.0)!
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing

        let attrString = NSMutableAttributedString(string: string)
        attrString.addAttribute(NSKernAttributeName, value: letterSpacing, range: NSRange(location: 0, length: string.utf16.count))
        attrString.addAttributes([NSFontAttributeName: font ?? defaultFont], range: NSRange(location: 0, length: string.utf16.count))
        attrString.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSRange(location: 0, length: string.utf16.count))

        return attrString
    }
    
    @IBAction func closeAction(_ sender: Any) {
        delegate?.didTapClose(in: self)
    }

    // MARK: ScrollView Delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if  scrollView.contentOffset.y > 0 {
            scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: 0)
        }
    }
}
