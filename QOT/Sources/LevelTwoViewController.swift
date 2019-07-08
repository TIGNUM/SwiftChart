//
//  LevelTwoViewController.swift
//  QOT
//
//  Created by karmic on 14.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import Anchorage

final class LevelTwoViewController: AbstractLevelTwoViewController {

    // MARK: - Properties

    var interactor: LevelTwoInteractorInterface?
    private lazy var levelThreeViewController = LevelThreeViewController(configure: LevelThreeConfigurator.make())
    private lazy var tableView: UITableView = {
        return UITableView(backgroundColor: .clear,
                           seperatorStyle: .singleLine,
                           delegate: self,
                           dataSource: self,
                           dequeables: AbstractTableViewCell.self)
    }()

    // MARK: - Init

    init(configure: Configurator<LevelTwoViewController>) {
        super.init(nibName: nil, bundle: nil)
        configure(self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.viewDidLoad()
    }
}

// MARK: - Private
private extension LevelTwoViewController {
}

// MARK: - Actions

private extension LevelTwoViewController {

}

// MARK: - LevelTwoViewControllerInterface

extension LevelTwoViewController: LevelTwoViewControllerInterface {
    func setupView() {
        view.addSubview(tableView)
        tableView.edgeAnchors == view.edgeAnchors
    }

    func presentLevelThree() {
        present(levelThreeViewController, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension LevelTwoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AbstractTableViewCell = tableView.dequeueCell(for: indexPath)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        interactor?.didTapCell(at: indexPath)
    }
}
