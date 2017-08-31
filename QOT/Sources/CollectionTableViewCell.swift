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

    @IBOutlet weak var collectionView: UICollectionView!
    weak var delegate: CollectionViewCellDelegate?

    fileprivate var dataModel: [PrepareChatObject] = []
    fileprivate var display: ChoiceListDisplay = .flow

    func inputWithDataModel(dataModel: [PrepareChatObject]!, display: ChoiceListDisplay) {
        self.dataModel = dataModel
        self.display = display
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        setup()
    }

    func setup() {
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
        let object = self.dataModel[indexPath.row]
        let title = object.title

        let cell: PrepareCollectionViewCell = collectionView.dequeueCell(for: indexPath)
        cell.setStyle(cellStyle: object.style, name: title, display: display)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 40
        let font = UIFont(name: "BentonSans", size: 16)!
        var cellHeight: CGFloat = 40
        var cellWidth: CGFloat = self.dataModel[indexPath.row].title.width(withConstrainedHeight: 0, font: font) + padding

        let maxCellWidth: CGFloat = 285

        switch display {
        case .flow:
            fallthrough
        case .list:
            if cellWidth > maxCellWidth {
                cellWidth = maxCellWidth
                cellHeight = self.dataModel[indexPath.row].title.height(withConstrainedWidth: cellWidth, font: font) + padding
            }
        }
        return CGSize(width: cellWidth, height: cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        switch display {
        case .flow:
            return 6.0
        case .list:
            return 1000.0
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 6.0
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectItemAtIndex(indexPath.item, in: self)
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
