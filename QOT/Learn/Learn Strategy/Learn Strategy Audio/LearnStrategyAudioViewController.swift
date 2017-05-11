//
//  LearnStrategyAudioViewController.swift
//  QOT
//
//  Created by karmic on 21.04.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import ReactiveKit
import Bond
import AVFoundation
import AVKit

final class LearnStrategyAudioViewController: UIViewController {

    // MARK: - Properties

    let disposeBag = DisposeBag()
    @IBOutlet fileprivate weak var tableView: UITableView!
    fileprivate let viewModel: LearnStrategyAudioViewModel
    weak var delegate: LearnContentItemViewControllerDelegate?
    lazy var audioView = LearnStrategyAudioPlayerView.instatiateFromNib()

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

        tableView.registerDequeueable(LearnStrategyTitleAudioCell.self)
        tableView.registerDequeueable(LearnStrategyPlaylistAudioCell.self)
        tableView.estimatedRowHeight = 10
        tableView.rowHeight = UITableViewAutomaticDimension

        viewModel.currentPosition.map { [unowned self] (interval) -> String in            
            return self.stringFromTimeInterval(interval: interval)
        }.bind(to: audioView.currentPositionLabel)

        viewModel.trackDuration.map { [unowned self] (interval) -> String in
            return self.stringFromTimeInterval(interval: interval)
        }.bind(to: audioView.trackDurationLabel)

        viewModel.currentPosition.observeNext { [unowned self] (interval) in
            let value = self.progress(currentPosition: interval, trackDuration: self.viewModel.trackDuration.value)
            self.audioView.audioWaveformView.setProgress(value: value)
        }.dispose(in: disposeBag)

        viewModel.soundPattern.observeNext { [unowned self] (data) in
            self.audioView.audioWaveformView.data = data
        }.dispose(in: disposeBag)

        viewModel.updates.observeNext { [unowned self] (_) in
            self.tableView.reloadData()
        }.dispose(in: disposeBag)
    }

    private func stringFromTimeInterval(interval: TimeInterval?) -> String {
        guard let interval = interval else {
            return "00:00"
        }

        let formatter = DateComponentsFormatter()
        formatter.zeroFormattingBehavior = .pad
        formatter.allowedUnits = [.minute, .second]
        let time = formatter.string(from: interval)
        
        return time ?? "00:00"
    }

    private func progress(currentPosition: TimeInterval, trackDuration: TimeInterval) -> CGFloat {
        return trackDuration > 0 ? CGFloat(currentPosition / trackDuration) : 0        
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension LearnStrategyAudioViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return viewModel.audioItemsCount
        default:
            fatalError("Invalid section")
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell: LearnStrategyTitleAudioCell = tableView.dequeueCell(for: indexPath)
            cell.setUp(title: viewModel.headline, subTitle: viewModel.subHeadline)
            return cell
        case 1:
            let item = viewModel.audioItem(at: indexPath.item)
            let cell: LearnStrategyPlaylistAudioCell = tableView.dequeueCell(for: indexPath)
            cell.setUp(title: item.title, playing: item.playing)
            return cell
        default:
            fatalError("Invalid section")
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return section == 1 ? audioView : nil
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        viewModel.playItem(at: indexPath)
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 1 ? 100 : 0
    }
}
