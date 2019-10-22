//
//  CoachMarksViewController.swift
//  QOT
//
//  Created by karmic on 22.10.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import AVFoundation

final class CoachMarksViewController: UIViewController {

    // MARK: - Properties
    var interactor: CoachMarksInteractorInterface?
    var router: CoachMarksRouterInterface?
    var player: AVQueuePlayer? = AVQueuePlayer()
    var playerLayer: AVPlayerLayer?
    var playerLooper: AVPlayerLooper?
    let mediaName = "walkThorugh_search"
    let mediaExtension = "mp4"
    @IBOutlet private weak var buttonBack: UIButton!
    @IBOutlet private weak var buttonContinue: UIButton!
    @IBOutlet private weak var viedoView: UIView!

    // MARK: - Init
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        player?.play()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer?.frame = viedoView.bounds
    }
}

// MARK: - Private
private extension CoachMarksViewController {

}

// MARK: - Actions
private extension CoachMarksViewController {
    @IBAction func didTapBack() {

    }

    @IBAction func didTapContinue() {

    }
}

// MARK: - CoachMarksViewControllerInterface
extension CoachMarksViewController: CoachMarksViewControllerInterface {
    func setupView() {
        if let media = Bundle.main.url(forResource: mediaName, withExtension: mediaExtension), let player = player {
            let playerItem = AVPlayerItem(url: media)
            playerLooper = AVPlayerLooper(player: player, templateItem: playerItem)
        } else {
            playerLooper = nil
        }

        let playerLayer = AVPlayerLayer(player: player)
        viedoView.layer.addSublayer(playerLayer)
        self.playerLayer = playerLayer
    }
}
