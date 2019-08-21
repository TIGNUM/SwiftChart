//
//  MyDataHeatMapTableViewCell.swift
//  QOT
//
//  Created by Voicu on 21.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

protocol MyDataHeatMapTableViewCellDelegate: class {
    
}

class MyDataHeatMapTableViewCell: UITableViewCell, Dequeueable {
    // MARK: - Properties
    
    weak var delegate: MyDataHeatMapTableViewCellDelegate?
    @IBOutlet weak var tempImageView: UIImageView!
    
    func configure() {
        
    }
}
