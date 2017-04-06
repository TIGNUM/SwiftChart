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

    func didSelectItemAtIndexPath(indexPath: IndexPath)
}

class CollectionTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegateRightAlignedLayout, Dequeueable {

    @IBOutlet public weak var cellTitleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    weak var delegate: CollectionViewCellDelegate?
    var dataModel: [Any] = []

    public func inputWithDataModel(dataModel: [Any]!) {
        self.dataModel = dataModel
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self

        self.collectionView.registerDequeueable(InputCollectionViewCell.self)
        self.collectionView.registerDequeueable(NavigationCollectionViewCell.self)

        let collectionFlow = UICollectionViewRightAlignedLayout()
        self.collectionView.collectionViewLayout = collectionFlow
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension CollectionTableViewCell {

    // MARK: - UICollectionViewDelegate, UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        if let obj = self.dataModel as? [ChatMessageNavigation] {
            return  obj.numberOfItems(inSection: section)
        } else if let obj = self.dataModel as? [ChatMessageInput] {
            return  obj.numberOfItems(inSection: section)
        }
        return 0
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let obj = self.dataModel as? [ChatMessageNavigation] {
            let title = obj.item(at: indexPath.row).title
            let cell: NavigationCollectionViewCell = collectionView.dequeueCell(for: indexPath)
            cell.titleLbl.text = title
            cell.addDashedBorder(lineWidth: 2)
            return cell
        } else if let obj = self.dataModel as? [ChatMessageInput] {
            let title = obj.item(at: indexPath.row).title
            let cell: InputCollectionViewCell = collectionView.dequeueCell(for: indexPath)
            cell.titleLbl.text = title
            return cell
        }
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.didSelectItemAtIndexPath(indexPath: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let obj = self.dataModel as? [ChatMessageNavigation] {
            let cellWidth = obj.item(at: indexPath.row).title.width(withConstrainedHeight: 00, font: UIFont(name: "BentonSans", size: 16)!) + 25
            return CGSize(width: cellWidth, height: 40)

        } else if let obj = self.dataModel as? [ChatMessageInput] {
            let cellWidth = obj.item(at: indexPath.row).title.width(withConstrainedHeight: 00, font: UIFont(name: "BentonSans", size: 16)!) + 25
            return CGSize(width: cellWidth, height: 40)
        }
        return CGSize()
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
