//
//  AnswerCollectionTableViewCell.swift
//  QOT
//
//  Created by Type-IT on 30.03.2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import UICollectionViewRightAlignedLayout

protocol AnswerCollectionViewCellDelegate {

    func didSelectItemAtIndexPath(indexPath: IndexPath)
}

class AnswerCollectionTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegateRightAlignedLayout, Dequeueable {

    @IBOutlet weak var collectionView: UICollectionView!
    var delegate: AnswerCollectionViewCellDelegate?
    var dataSource: [ChatMessageNavigation] = []

    public func withDataModel(dataModel: [ChatMessageNavigation]!) {
        self.dataSource = dataModel
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self

        self.collectionView.registerDequeueable(AnswerCollectionViewCell.self)

        // re-write the class in swift later!!
        let collectionFlow = UICollectionViewRightAlignedLayout()
        self.collectionView.collectionViewLayout = collectionFlow

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    public func heightOfCollectionViewBasedOnNumberOfItems() -> Int {
        let numberOfcells = self.dataSource.count
        let screenSize: CGRect = UIScreen.main.bounds
        var totalWidth: Int = 0
        for i: Int  in 1...numberOfcells {
            let cell: AnswerCollectionViewCell = self.collectionView.dequeueCell(for: IndexPath.init(row: i, section: 1))
            totalWidth += Int(cell.frame.width+10)
        }
        totalWidth /= Int(screenSize.width)
        return totalWidth
    }
}

extension AnswerCollectionTableViewCell {

    // MARK: - UICollectionViewDelegate, UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource.count
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let title = self.dataSource.item(at: indexPath.row).title
        let cell: AnswerCollectionViewCell = collectionView.dequeueCell(for: indexPath)

        cell.titleLbl.text = title
        cell.addDashedBorder(color: UIColor.gray.cgColor, lineWidth: 3.0)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.didSelectItemAtIndexPath(indexPath: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = self.dataSource.item(at: indexPath.row).title.width(withConstrainedHeight: 00, font: UIFont(name: "BentonSans", size: 16)!) + 25
        return CGSize(width: cellWidth, height: 40)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
}

extension String {
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)

        return boundingBox.width
    }
}

