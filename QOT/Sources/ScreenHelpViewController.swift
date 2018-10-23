//
//  ScreenHelpViewController.swift
//  QOT
//
//  Created by Lee Arromba on 13/12/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Kingfisher

final class ScreenHelpViewController: UIViewController {

    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var minimiseButton: UIBarButtonItem!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    private var avPlayerObserver: AVPlayerObserver?
    var interactor: ScreenHelpInteractorInterface!
    var helpItem: ScreenHelp.Item?

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
        guard let helpItem = helpItem else { return }
        navigationBar.topItem?.title = helpItem.title.uppercased()
        imageView.kf.setImage(with: helpItem.imageURL)
        messageLabel.attributedText = NSAttributedString(string: helpItem.message,
                                                         letterSpacing: 1.4,
                                                         font: .DPText2,
                                                         lineSpacing: 14,
                                                         textColor: .white
        )
    }

    // MARK: - action

    @IBAction private func minimiseButtonPressed(_ sender: UIBarButtonItem) {
        interactor.didTapMinimiseButton()
    }

    @IBAction private func imageViewTapped(_ sender: UITapGestureRecognizer) {
        guard let url = helpItem?.videoURL else { return }
        interactor.didTapVideo(with: url)
    }
}

// MARK: - ScreenHelpViewControllerInterface

extension ScreenHelpViewController: ScreenHelpViewControllerInterface {

    func streamVideo(videoURL: URL) {
        let playerViewController = stream(videoURL: videoURL)
        if let playerItem = playerViewController.player?.currentItem {
            avPlayerObserver = AVPlayerObserver(playerItem: playerItem)
            avPlayerObserver?.onStatusUpdate { (player) in
                if playerItem.status == .failed {
                    playerViewController.presentNoInternetConnectionAlert(in: playerViewController)
                }
            }
        }
    }

    func updateHelpItem(_ helpItem: ScreenHelp.Item?) {
        self.helpItem = helpItem
        reload()
    }
}
