//
//  TextField.swift
//  QOT
//
//  Created by karmic on 03.07.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit

protocol TextFieldDelegate: class {
    func textFieldDidDelete(_ textField: TextField)
}

class TextField: UITextField {

    weak var textFieldDelegate: TextFieldDelegate?

    override func deleteBackward() {
        super.deleteBackward()
        textFieldDelegate?.textFieldDidDelete(self)
    }
}
