//
//  PopUpViewController.swift
//  QOT
//
//  Created by Ashish Maheshwari on 19.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

protocol PopUpViewControllerProtocol: class {
    func leftButtonAction()
    func rightButtonAction()
    func cancelAction()
}

final class PopUpViewController: UIViewController, ScreenZLevel {

    struct Config {
        let title: String
        let description: String
        let rightButtonTitle: String
        let leftButtonTitle: String
    }

    // MARK: - Properties

    private let config: Config
    @IBOutlet private weak var rightButton: UIButton!
    @IBOutlet private weak var leftButton: UIButton!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var backgroundView: UIView!
    @IBOutlet private weak var containerView: UIView!

    weak var delegate: PopUpViewControllerProtocol?

    // MARK: - Init

    init(with config: PopUpViewController.Config, delegate: PopUpViewControllerProtocol?) {
        self.config = config
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addGestures()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    @objc func handleGesture(gesture: UISwipeGestureRecognizer) {
        cancel()
    }

    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        cancel()
    }

    private func cancel() {
        self.delegate?.cancelAction()
    }

    private func addGestures() {
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeDown.direction = .down
        containerView.addGestureRecognizer(swipeDown)

        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        backgroundView.addGestureRecognizer(tap)
    }

    private func setupView() {
        backgroundView.backgroundColor = .carbon60
        containerView.backgroundColor = .carbonDark
        rightButton.setTitle(config.rightButtonTitle, for: .normal)
        leftButton.setTitle(config.leftButtonTitle, for: .normal)
        rightButton.corner(radius: Layout.cornerRadius20, borderColor: .accent40)
        leftButton.corner(radius: Layout.cornerRadius20, borderColor: .accent40)
        descriptionLabel.attributedText = formatted(description: config.description)
        titleLabel.text = config.title
    }

    private func formatted(description: String) -> NSAttributedString? {
        return NSAttributedString(string: description,
                                  letterSpacing: 0.3,
                                  font: .sfProtextRegular(ofSize: 14) ,
                                  lineSpacing: 8.0,
                                  textColor: .sand70)
    }

    @IBAction func leftButtonAction(_ sender: Any) {
        delegate?.leftButtonAction()
    }

    @IBAction func rightButtonAction(_ sender: Any) {
        delegate?.rightButtonAction()
    }
}

// MARK: Bottom Navigation
extension PopUpViewController {
    @objc override public func bottomNavigationLeftBarItems() -> [UIBarButtonItem]? {
        return nil
    }

    @objc override public func bottomNavigationRightBarItems() -> [UIBarButtonItem]? {
        return nil
    }
}
