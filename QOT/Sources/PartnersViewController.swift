//
//  PartnersViewController.swift
//  QOT
//
//  Created by karmic on 19.04.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import RSKImageCropper

final class PartnersViewController: UIViewController, PartnersViewControllerInterface, PageViewControllerNotSwipeable {

    @IBOutlet private weak var backgroundImageView: UIImageView!
    @IBOutlet private(set) weak var scrollView: UIScrollView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var scrollViewContentHeightConstraint: NSLayoutConstraint!
    private let cellWidth: CGFloat = 186
    private let cellSpacing: CGFloat = 4
    private let leftMargin: CGFloat = 26
    private let keyboardListner = KeyboardListener()
    private var partners: [Partners.Partner] = []
    private var editingIndex: Int?
    var interactor: PartnersInteractorInterface?
    var imagePickerController: ImagePickerController?

    private var editButton: UIBarButtonItem? {
        return navigationItem.rightBarButtonItem
    }

    init(configure: Configurator<PartnersViewController>) {
        super.init(nibName: nil, bundle: nil)
        configure(self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.registerDequeueable(PartnerCell.self)

        let leftButton = UIBarButtonItem(withImage: R.image.ic_minimize())
        leftButton.target = self
        leftButton.action = #selector(didTapClose(_ :))
        navigationItem.leftBarButtonItem = leftButton

        let rightButton = UIBarButtonItem(withImage: R.image.ic_edit())
        rightButton.target = self
        rightButton.action = #selector(didTapEdit(_ :))
        rightButton.tintColor = .white40
        navigationItem.rightBarButtonItem = rightButton

        interactor?.viewDidLoad()
        setBackgroundColor()
        setupHeadline()

        keyboardListner.onStateChange { [unowned self] (state) in
            self.handleKeyboardChange(state: state)
        }

        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
    }

    @available(iOS 11.0, *)
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()

        syncScrollViewLayout()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        let rightInset = ceil(view.bounds.width - leftMargin - cellWidth)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: leftMargin, bottom: 0, right: rightInset)
        collectionView.reloadData()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        syncScrollViewLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        keyboardListner.startObserving()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        updateCurrentCell(at: 0)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        keyboardListner.stopObserving()
    }

    func setup(partners: [Partners.Partner]) {
        self.partners = partners
        collectionView.reloadData()
    }

    func reload(partner: Partners.Partner) {
        guard let index = partners.index(where: { $0.localID == partner.localID }) else {
            assertionFailure("Trying to reload a partner that doesn't exist.")
            return
        }
        collectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
    }
}

// MARK: - Private

private extension PartnersViewController {

    @objc func didTapClose(_ sender: UIBarButtonItem) {
        interactor?.didTapClose(partners: partners)
    }

    @objc func didTapEdit(_ sender: UIBarButtonItem) {
        if editingIndex == nil, let index = page(contentOffset: collectionView.contentOffset) {
            startEditing(index: index)
        } else {
            stopEditing()
        }
    }

    func syncScrollViewLayout() {
        let contentHeight = view.bounds.height - safeAreaInsets.top - safeAreaInsets.bottom
        scrollViewContentHeightConstraint.constant = contentHeight
        scrollView.contentInset.top = safeAreaInsets.top
        let spaceBellowCollectionView = contentHeight - collectionView.frame.maxY
        let bottomInset = max(keyboardListner.state.height - spaceBellowCollectionView, safeAreaInsets.bottom)
        scrollView.contentInset.bottom = bottomInset
    }

    func handleKeyboardChange(state: KeyboardListener.State) {
        switch state {
        case .idle:
            break
        case .willChange(_, _, let duration, let curve):
            syncScrollViewLayout()
            let options = UIViewAnimationOptions(curve: curve)
            let contentHeight = scrollViewContentHeightConstraint.constant
            let minY = scrollView.contentInset.top
            let yPos = max(contentHeight - scrollView.bounds.height + scrollView.contentInset.bottom, -minY)
            UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
                self.scrollView.contentOffset.y = yPos
            })
        }
    }

    func startEditing(index: Int) {
        editingIndex = index
        (collectionView.visibleCells as? [PartnerCell])?.forEach { (cell) in
            if let indexPath = collectionView.indexPath(for: cell), indexPath.item == index {
                cell.setEditing(true)
            } else {
                cell.setEditing(false)
            }
        }
        syncEditButton()
    }

    func stopEditing() {
        editingIndex = nil
        (collectionView.visibleCells as? [PartnerCell])?.forEach { $0.setEditing(false) }
        syncEditButton()

        guard let page = page(contentOffset: collectionView.contentOffset) else { return }
        updateCurrentCell(at: page)
    }

    func syncEditButton() {
        editButton?.tintColor = editingIndex == nil ? .white40 : .white
    }

    var selectedPartner: Partners.Partner? {
        return page(contentOffset: collectionView.contentOffset).map { partners[$0] }
    }

    func setBackgroundColor() {
        backgroundImageView.image = R.image._1Learn()
        view.addFadeView(at: .top)
        scrollView.backgroundColor = .clear
    }

    func setupHeadline() {
        titleLabel.attributedText = NSMutableAttributedString(
            string: R.string.localized.meSectorMyWhyPartnersHeader(),
            letterSpacing: 2,
            font: Font.H1MainTitle,
            alignment: .left
        )
    }
}

extension PartnersViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return partners.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let partner = partners[indexPath.row]
        let cell: PartnerCell = collectionView.dequeueCell(for: indexPath)
        cell.configure(with: partner, isEditing: editingIndex == indexPath.row)
        cell.delegate = self

        return cell
    }
}

extension PartnersViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let height = floor(collectionView.frame.height - collectionView.contentInset.vertical)
        return CGSize(width: cellWidth, height: height)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        scrollToItemAtIndex(indexPath.row)
    }

    // PAGING

    private func scrollToItemAtIndex(_ index: Int) {
        guard index != page(contentOffset: collectionView.contentOffset) else { return }

        let newOffset = contentOffsetForItem(at: index, scrollView: collectionView)
        collectionView.setContentOffset(newOffset, animated: true)
    }

    private func page(contentOffset: CGPoint) -> Int? {
        let itemCount = collectionView.numberOfItems(inSection: 0)
        let itemAndSpaceWidth = cellWidth + cellSpacing

        guard itemCount > 0, itemAndSpaceWidth > 0 else {
            return nil
        }

        let x = contentOffset.x + collectionView.contentInset.left
        var page = Int(x / itemAndSpaceWidth)

        let remainder = x - (CGFloat(page) * itemAndSpaceWidth)
        if remainder > (cellWidth / 2) + cellSpacing {
            page += 1
        }
        page = min(max(0, page), itemCount - 1)

        return page
    }

    private func contentOffsetForItem(at index: Index, scrollView: UIScrollView) -> CGPoint {
        let x = -collectionView.contentInset.left + (CGFloat(index) * (cellWidth + cellSpacing))
        let y = -collectionView.contentInset.top
        return CGPoint(x: x, y: y)
    }
}

extension PartnersViewController: PartnerCellDelegate {

    func didTapShareButton(at partner: Partners.Partner?) {
        guard let partner = selectedPartner else { return }
        interactor?.didTapShare(partner: partner, in: partners)
    }

    func willStartEditing(in cell: PartnerCell) {
        guard let index = collectionView.indexPath(for: cell)?.item else { return }
        scrollToItemAtIndex(index)
    }

    func didStartEditing(in cell: PartnerCell) {
        guard let index = collectionView.indexPath(for: cell)?.item else { return }
        startEditing(index: index)
    }

    func didTapDone(in cell: PartnerCell) {
        stopEditing()
    }

    func didTapEditPhoto(in cell: PartnerCell) {
        guard let index = collectionView.indexPath(for: cell)?.item else { return }
        startEditing(index: index)
        imagePickerController?.show(in: self)
    }
}

extension PartnersViewController: ImagePickerControllerDelegate {

    func imagePickerController(_ imagePickerController: ImagePickerController, selectedImage image: UIImage) {
        guard let index = page(contentOffset: collectionView.contentOffset) else { return }
        let partner = partners[index]
        interactor?.updateImage(image, partner: partner)
    }
}

// MARK: - UIScrollViewDelegate

extension PartnersViewController: UIScrollViewDelegate {

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if let page = page(contentOffset: targetContentOffset.pointee) {
            targetContentOffset.pointee.x = contentOffsetForItem(at: page, scrollView: scrollView).x
            updateCurrentCell(at: page)
        }
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.scrollViewDidScroll(scrollView)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let page = page(contentOffset: scrollView.contentOffset) {
            updateCurrentCell(at: page)
        }
    }

    func updateCurrentCell(at page: Index) {
        collectionView.visibleCells.forEach { ($0 as? PartnerCell)?.updateActionButtons(false) }
        let partnerCell = collectionView.cellForItem(at: IndexPath(item: page, section: 0)) as? PartnerCell
        partnerCell?.updateActionButtons(selectedPartner?.isValid ?? false)
    }
}

/*
 We use this in the xib. It stops the collection view from auto scrolling to visible when a UITextField becomes first
 responder and from randomly hiding the keyboard.\
 */
final class PartnersCollectionView: UICollectionView {

    override func scrollRectToVisible(_ rect: CGRect, animated: Bool) {
        // Do nothing
    }
}
