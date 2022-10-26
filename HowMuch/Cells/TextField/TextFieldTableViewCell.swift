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
    case menu([String], initial: String, hiddenInput: Bool)
}

class TextFieldTableViewCell: UITableViewCell {
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var fieldContent: UITextField!
    @IBOutlet weak var constraintTop: NSLayoutConstraint!
    @IBOutlet weak var constraintBottom: NSLayoutConstraint!
    @IBOutlet weak var buttonMenu: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func render(type: TextFieldTableViewCellType,
                       title: String,
                       placeholder: String,
                       keyboard: UIKeyboardType = .default,
                       constraint: (top: CGFloat?, bottom: CGFloat?)? = nil) {
        switch type {
        case .title:
            labelTitle.font = UIFont.systemFont(ofSize: 28, weight: .bold)
            fieldContent.font = UIFont.systemFont(ofSize: 22, weight: .bold)
            buttonMenu.isHidden = true
        case .body:
            labelTitle.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            fieldContent.font = UIFont.systemFont(ofSize: 17, weight: .regular)
            buttonMenu.isHidden = true
        case .menu(let actions, let initial, let hiddenInput):
            labelTitle.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            fieldContent.font = UIFont.systemFont(ofSize: 17, weight: .regular)
            buttonMenu.isHidden = false
            fieldContent.isUserInteractionEnabled = !hiddenInput
            buttonMenu.setTitle(initial, for: .normal)
            configureMenu(actions: actions)
        }
        labelTitle.text = title
        fieldContent.placeholder = placeholder
        fieldContent.keyboardType = keyboard
        if let top = constraint?.top {
            self.constraintTop.constant = top
        }
        if let bottom = constraint?.bottom {
            self.constraintBottom.constant = bottom
        }
        layoutIfNeeded()
    }
    
    private func configureMenu(actions: [String]) {
        var children: [UIAction] = []
        actions.forEach { title in
            let action = UIAction(title: title) { [weak self] (action) in
                self?.buttonMenu.setTitle(action.title, for: .normal)
           }
            children.append(action)
        }

        let menu = UIMenu(options: .displayInline,
                          children: children)
        buttonMenu.menu = menu
        buttonMenu.showsMenuAsPrimaryAction = true
    }
}
