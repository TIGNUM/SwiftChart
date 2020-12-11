//
//  PopUpCopyrightViewController.swift
//  QOT
//
//  Created by Anais Plancoulaine on 26.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import SafariServices
import qot_dal

protocol PopUpCopyrightViewControllerProtocol: class {
    func cancelAction()
}

final class PopUpCopyrightViewController: BaseViewController, ScreenZLevelOverlay {

    struct Config {
        let description: String
    }

    // MARK: - Properties
    var copyrightURL: String?
    var descriptionText: String?
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    weak var delegate: PopUpCopyrightViewControllerProtocol?

    // MARK: - Init

    init(delegate: PopUpCopyrightViewControllerProtocol?, copyrightURL: String?, description: String?) {
        self.copyrightURL = copyrightURL
        self.delegate = delegate
        self.descriptionText = description
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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    @objc func handleGesture(gesture: UISwipeGestureRecognizer) {
        cancel()
    }

    @objc func tapToDismiss(gesture: UITapGestureRecognizer) {
        cancel()
    }

    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        //track tap gesture
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
        NewThemeView.dark.apply(containerView)
        NewThemeView.dark.apply(backgroundView)
        descriptionLabel.text = (descriptionText ?? "") + (copyrightURL ?? "")
    }

    @IBAction func didTapClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
