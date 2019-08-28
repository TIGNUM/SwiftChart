//
//  PopUpCopyrightViewController.swift
//  QOT
//
//  Created by Anais Plancoulaine on 26.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import SafariServices

protocol PopUpCopyrightViewControllerProtocol: class {
    func cancelAction()
}

final class PopUpCopyrightViewController: UIViewController, ScreenZLevel {

    struct Config {
        let description: String
    }

    // MARK: - Properties
    var copyrightURL: String?
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    weak var delegate: PopUpCopyrightViewControllerProtocol?

    // MARK: - Init

    init(delegate: PopUpCopyrightViewControllerProtocol?, copyrightURL: String?) {
        self.copyrightURL = copyrightURL
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

    @objc func handleGesture(gesture: UISwipeGestureRecognizer) {
        cancel()
    }

    @objc func tapToDismiss(gesture: UITapGestureRecognizer) {
        cancel()
    }

    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        showSafariVC(for: copyrightURL ?? "")
    }

    private func cancel() {
        self.delegate?.cancelAction()
    }

    private func addGestures() {
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeDown.direction = .down
        containerView.addGestureRecognizer(swipeDown)
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        containerView.addGestureRecognizer(tap)
        let tapToDismiss = UITapGestureRecognizer(target: self, action: #selector(self.tapToDismiss))
        backgroundView.addGestureRecognizer(tapToDismiss)
    }

    private func setupView() {
        containerView.backgroundColor = .carbon
        backgroundView.backgroundColor = UIColor.carbon.withAlphaComponent(0.95)
        descriptionLabel.text = R.string.localized.copyrightText() + (copyrightURL ?? "")
    }

    func showSafariVC(for url: String) {
        guard let url = URL(string: url) else {
            // show invalid url
            return
        }
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true)
    }
}

// MARK: Bottom Navigation

extension PopUpCopyrightViewController {
    @objc override public func bottomNavigationLeftBarItems() -> [UIBarButtonItem]? {
        return nil
    }

    @objc override public func bottomNavigationRightBarItems() -> [UIBarButtonItem]? {
        return nil
    }
}

