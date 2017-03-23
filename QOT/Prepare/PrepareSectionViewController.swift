//
//  PrepareSectionViewController.swift
//  QOT
//
//  Created by karmic on 22/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

class PrepareSectionViewController: UIViewController {
    
    // MARK: - Properties
    let viewModel: PrepareChatBotViewModel
    fileprivate var collectionView: UICollectionView?
    weak var delegate: PrepareChatBotDelegate?
    
    // MARK: - Life Cycle

    init(viewModel: PrepareChatBotViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .green
    }
}

extension PrepareSectionViewController {

    fileprivate func setupCollectionView() {
        let flowLayout = UICo
        self.collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: UICollectionViewLayout())
    }
}
