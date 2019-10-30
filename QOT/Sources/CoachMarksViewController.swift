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
    private let mediaExtension = "mp4"
    private var currentPage: Int = 0
    @IBOutlet private weak var buttonBack: UIButton!
    @IBOutlet private weak var buttonContinue: UIButton!
    @IBOutlet private weak var viedoView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!

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
    func setupPlayer(_ mediaName: String) {
        let playerLayer = AVPlayerLayer(player: player)
        viedoView.layer.addSublayer(playerLayer)
        self.playerLayer = playerLayer
    }

    func setPlayerLooper(_ mediaName: String) {
        if let media = Bundle.main.url(forResource: mediaName, withExtension: mediaExtension),
            let player = player {
            let playerItem = AVPlayerItem(url: media)
            playerLooper = AVPlayerLooper(player: player, templateItem: playerItem)
        } else {
            playerLooper = nil
        }
    }

    func setupLabels(_ title: String, subtitle: String) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }

    func setupButtons(_ hideBackButton: Bool, _ rightButtonImage: UIImage?) {
        buttonBack.isHidden = hideBackButton
        buttonContinue.setImage(rightButtonImage, for: .normal)
    }
}

// MARK: - Actions
private extension CoachMarksViewController {
    @IBAction func didTapBack() {
        interactor?.loadPreviousStep(page: currentPage)
    }

    @IBAction func didTapContinue() {
        interactor?.loadNextStep(page: currentPage)
    }
}

// MARK: - CoachMarksViewControllerInterface
extension CoachMarksViewController: CoachMarksViewControllerInterface {
    func setupView(_ viewModel: CoachMark.ViewModel) {
        updateView(viewModel)
        setupPlayer(viewModel.mediaName)
    }

    func updateView(_ viewModel: CoachMark.ViewModel) {
        currentPage = viewModel.page
        setPlayerLooper(viewModel.mediaName)
        setupLabels(viewModel.title, subtitle: viewModel.subtitle)
        setupButtons(viewModel.hideBackButton, viewModel.rightButtonImage)
    }
}
