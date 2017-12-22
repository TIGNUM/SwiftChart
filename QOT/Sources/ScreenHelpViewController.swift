//
//  ScreenHelpViewController.swift
//  QOT
//
//  Created by Lee Arromba on 13/12/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Kingfisher

class ScreenHelpViewController: UIViewController {
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var minimiseButton: UIBarButtonItem!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!

    var interactor: ScreenHelpInteractorInterface!

    fileprivate var viewModel: ScreenHelp.ViewModel!

    init(configurator: Configurator<ScreenHelpViewController>) {
        super.init(nibName: nil, bundle: nil)
        configurator(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor.viewDidLoad()
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - private

    private func setup() {
        navigationBar.applyDefaultStyle()
        contentView.layer.cornerRadius = 15.0
        view.addFadeView(at: .top)
        view.bringSubview(toFront: navigationBar)
    }

    private func reload() {
        navigationBar.topItem?.title = viewModel.title
        imageView.kf.setImage(with: viewModel.imageURL)
        messageLabel.attributedText = NSAttributedString(
            string: viewModel.message,
            letterSpacing: 1.4,
            font: UIFont.bentonBookFont(ofSize: 15),
            lineSpacing: 14,
            textColor: .white
        )
    }

    // MARK: - action

    @IBAction private func minimiseButtonPressed(_ sender: UIBarButtonItem) {
        interactor.didTapMinimiseButton()
    }

    @IBAction private func imageViewTapped(_ sender: UITapGestureRecognizer) {
        guard let url = viewModel.videoURL else {
            return
        }
        interactor.didTapVideo(with: url)
    }
}

// MARK: - ScreenHelpViewControllerInterface

extension ScreenHelpViewController: ScreenHelpViewControllerInterface {
    func updateViewModel(_ viewModel: ScreenHelp.ViewModel) {
        self.viewModel = viewModel
        reload()
    }
}
