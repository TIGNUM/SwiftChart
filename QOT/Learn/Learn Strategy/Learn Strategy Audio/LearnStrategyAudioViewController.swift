//
//  LearnStrategyAudioViewController.swift
//  QOT
//
//  Created by karmic on 21.04.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import AVFoundation

final class LearnStrategyAudioViewController: UIViewController {

    // MARK: - Properties

    @IBOutlet fileprivate weak var tableView: UITableView!
    fileprivate let viewModel: LearnStrategyAudioViewModel
    fileprivate var player: AVAudioPlayer?
    weak var delegate: LearnStrategyViewControllerDelegate?

    // MARK: - Init

    init(viewModel: LearnStrategyAudioViewModel) {
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
        setupTableView()
        setupAudioPlayer()
        setupSoundPattern(audioTrack: viewModel.audioTrack(at: 0))
    }
}

// MARK: - AudioPlayer

private extension LearnStrategyAudioViewController {

    func playOrStopAudioTrack(at index: Index) {
        if player?.isPlaying == true {
            stopAudioTrack()
        } else {
            playAudioTrack()
        }
    }

    private func playAudioTrack() {
        // TODO
    }

    private func stopAudioTrack() {
        // TODO
    }
}

// MARK: - Private Helpers

private extension LearnStrategyAudioViewController {

    func setupAudioPlayer() {

    }

    func setupView() {
        // TODO
    }

    func setupTableView() {
        // TODO
    }

    func setupSoundPattern(audioTrack: AudioTrack) {
        // TODO
    }

    func updateSoundPattern(currentPosition: CGFloat, audioTrack: AudioTrack) {
        // TODO
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension LearnStrategyAudioViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.audioItemsCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // TODO

        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        playOrStopAudioTrack(at: indexPath.row)

        // TODO
    }
}
