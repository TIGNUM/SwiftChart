//
//  HomeViewController.swift
//  QOT
//
//  Created by karmic on 26.03.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import Anchorage

class HomeViewController: UIViewController {

    // MARK: - Properties

    private var transition: ComponentTransition?
    lazy var collectionView: UICollectionView = {
        return UICollectionView(layout: UICollectionViewFlowLayout(),
                                delegate: self,
                                dataSource: self,
                                dequeables: ComponentCollectionViewCell.self)
    }()

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
}

extension HomeViewController {
    func presentComponentDetailViewController(indexPath: IndexPath, controller: ComponentDetailViewController?) {
        // Get tapped cell location
        if let cell = collectionView.cellForItem(at: indexPath) as? ComponentCollectionViewCell {

            // Freeze highlighted state (or else it will bounce back)
            cell.freezeAnimations()

            // Get current frame on screen
            if let currentCellFrame = cell.layer.presentation()?.frame {

                // Convert current frame to screen's coordinates
                let cardPresentationFrameOnScreen = cell.superview?.convert(currentCellFrame, to: nil)

                // Get card frame without transform in screen's coordinates  (for the dismissing back later to original location)
                let cardFrameWithoutTransform = { () -> CGRect in
                    let center = cell.center
                    let size = cell.bounds.size
                    let r = CGRect(
                        x: center.x - size.width / 2,
                        y: center.y - size.height / 2,
                        width: size.width,
                        height: size.height
                    )
                    return cell.superview?.convert(r, to: nil) ?? .zero
                }()

                // Set up card detail view controller
                if let vc = controller {
                    let params = ComponentTransition.Params(fromComponentFrame: cardPresentationFrameOnScreen ?? .zero,
                                                            fromComponentFrameWithoutTransform: cardFrameWithoutTransform,
                                                            fromCell: cell)
                    transition = ComponentTransition(params: params)
                    vc.transitioningDelegate = transition

                    // If `modalPresentationStyle` is not `.fullScreen`, this should be set to true to make status bar depends on presented vc.
                    vc.modalPresentationCapturesStatusBarAppearance = true
                    vc.modalPresentationStyle = .custom

                    present(vc, animated: true, completion: { [weak cell] in
                        // Unfreeze
                        cell?.unfreezeAnimations()
                    })
                }
            }
        }
    }
}

// MARK: - Private

private extension HomeViewController {
    func setupCollectionView() {
        view.addSubview(collectionView)
        if #available(iOS 11.0, *) {
            collectionView.topAnchor == view.safeTopAnchor + 20
            collectionView.bottomAnchor == view.safeBottomAnchor
            collectionView.leadingAnchor == view.leadingAnchor
            collectionView.trailingAnchor == view.trailingAnchor
        } else {
            collectionView.topAnchor == view.topAnchor + 20
            collectionView.bottomAnchor == view.bottomAnchor
            collectionView.leadingAnchor == view.leadingAnchor
            collectionView.trailingAnchor == view.trailingAnchor
        }
        collectionView.delaysContentTouches = false
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            layout.sectionInset = .init(top: 0, left: 0, bottom: 64, right: 0)
        }
        collectionView.clipsToBounds = false
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ComponentCollectionViewCell = collectionView.dequeueCell(for: indexPath)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return .zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = R.storyboard.main().instantiateViewController(withIdentifier: "ComponentDetailViewControllerID") as? ComponentDetailViewController
        presentComponentDetailViewController(indexPath: indexPath, controller: controller)
    }
}
