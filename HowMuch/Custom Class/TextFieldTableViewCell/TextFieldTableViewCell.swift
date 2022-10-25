//
//  TextFieldTableViewCell.swift
//  HowMuch
//
//  Created by Matheus D Sanada on 24/10/22.
//

import UIKit

enum TextFieldTableViewCellType {
    case title
    case body
}

class TextFieldTableViewCell: UITableViewCell {
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var fieldContent: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func render(type: TextFieldTableViewCellType,
                       title: String,
                       placeholder: String,
                       keyboard: UIKeyboardType = .default) {
        switch type {
        case .title:
            labelTitle.font = UIFont.systemFont(ofSize: 28, weight: .bold)
            fieldContent.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        case .body:
            labelTitle.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            fieldContent.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        }
        labelTitle.text = title
        fieldContent.placeholder = placeholder
        fieldContent.keyboardType = keyboard
    }
}
