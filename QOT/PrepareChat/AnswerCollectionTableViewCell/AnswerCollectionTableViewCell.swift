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
    var dataSource: NSArray = []

    func initWithDataModel(dataModel: NSArray!){
        self.awakeFromNib()
        self.dataSource = dataModel
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.register(AnswerCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: AnswerCollectionViewCell.self))
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

        return UICollectionViewCell(AnswerCollectionViewCell().initWithTitle(title: String(describing: dataSource[indexPath.row])))
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize()
        return size
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.didSelectItemAtIndexPath(indexPath: indexPath)
    }

}
