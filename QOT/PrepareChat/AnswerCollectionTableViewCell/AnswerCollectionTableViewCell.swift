//
//  AnswerCollectionTableViewCell.swift
//  QOT
//
//  Created by Type-IT on 30.03.2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

protocol AnswerCollectionViewCellDelegate {

    func didSelectItemAtIndexPath(indexPath: IndexPath)
}

class AnswerCollectionTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    var delegate: AnswerCollectionViewCellDelegate?
    var dataSource: [ChatMessageNavigation] = []

    public func withDataModel(dataModel: [ChatMessageNavigation]!){
        self.dataSource = dataModel
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension AnswerCollectionTableViewCell {

    // MARK: - UICollectionViewDelegate, UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource.count
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let title = self.dataSource.item(at: indexPath.row).title
        
        collectionView.register(UINib(nibName: String(describing:AnswerCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing:AnswerCollectionViewCell.self))
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing:AnswerCollectionViewCell.self), for: indexPath) as! AnswerCollectionViewCell
        cell.titleLbl.text = title
        cell.addDashedBorder(color: UIColor.gray.cgColor, lineWidth: 2.0)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.didSelectItemAtIndexPath(indexPath: indexPath)
    }

}
