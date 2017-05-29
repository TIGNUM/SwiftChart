//
//  AnswerCollectionTableViewCell.swift
//  QOT
//
//  Created by Type-IT on 30.03.2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import UICollectionViewRightAlignedLayout

protocol CollectionViewCellDelegate: class {
    func didSelectItemAtIndex(_ index: Index, in cell: CollectionTableViewCell)
}

class CollectionTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegateRightAlignedLayout, Dequeueable {

    @IBOutlet weak var cellTitleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    weak var delegate: CollectionViewCellDelegate?
    var dataModel: [PrepareChatObject] = []

    func inputWithDataModel(dataModel: [PrepareChatObject]!) {
        self.dataModel = dataModel
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerDequeueable(PrepareCollectionViewCell.self)
        collectionView.collectionViewLayout = UICollectionViewRightAlignedLayout()
        collectionView.backgroundColor = .clear
    }
}

extension CollectionTableViewCell {

    // MARK: - UICollectionViewDelegate, UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  self.dataModel.numberOfItems(inSection: section)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let title = self.dataModel.item(at: indexPath.row).title
        let cell: PrepareCollectionViewCell = collectionView.dequeueCell(for: indexPath)
        let object = self.dataModel.item(at: indexPath.row)
        cell.setStyle(cellStyle: object.style, name: title)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = self.dataModel.item(at: indexPath.row).title.width(withConstrainedHeight: 00, font: UIFont(name: "BentonSans", size: 16)!) + 25
        return CGSize(width: cellWidth, height: 40)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectItemAtIndex(indexPath.item, in: self)
    }
}

extension String {
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)

        return boundingBox.width
    }
}

struct PrepareChatObject {

    var selected: Bool
    var title: String
    var localID: String
    var style: PrepareCollectionViewCell.Style

    init(title: String, localID: String, selected: Bool, style: PrepareCollectionViewCell.Style) {
        self.selected = selected
        self.title = title
        self.localID = localID
        self.style = style
    }
}
