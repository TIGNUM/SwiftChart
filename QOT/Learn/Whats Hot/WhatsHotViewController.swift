//
//  WhatsHotViewController.swift
//  QOT
//
//  Created by karmic on 30/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

protocol WhatsHotViewControllerDelegate: class {
    func didTapVideo(at index: Index, with whatsHot: WhatsHotItem, from view: UIView, in viewController: WhatsHotViewController)
    func didTapBookmark(at index: Index, with whatsHot: WhatsHotItem, in view: UIView, in viewController: WhatsHotViewController)
}

class WhatsHotViewController: UIViewController {

    @IBOutlet private weak var collectionView: UICollectionView!

    let viewModel: WhatsHotViewModel
    weak var delegate: WhatsHotViewControllerDelegate?

    // MARK: - Life Cycle

    init(viewModel: WhatsHotViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black
        collectionView.registerDequeueable(WhatsHotCell.self)
    }
}

extension WhatsHotViewController: UICollectionViewDelegateFlowLayout {
    
}

extension WhatsHotViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.itemCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let content = viewModel.item(at: indexPath.item)
        let cell: WhatsHotCell = collectionView.dequeueCell(for: indexPath)
        cell.setup( number: content.identifier,
                    thought: content.subtitle,
                    headline: content.text,
                    duration: content.mediaInformation,
                    placeholderURL: content.placeholderURL)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 376, height: 352)
    }
}
