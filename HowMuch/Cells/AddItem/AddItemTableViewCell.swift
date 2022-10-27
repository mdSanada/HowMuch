//
//  AddItemTableViewCell.swift
//  HowMuch
//
//  Created by Matheus D Sanada on 24/10/22.
//

import UIKit

class AddItemTableViewCell: UITableViewCell {
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelQuantity: UILabel!
    @IBOutlet weak var labelValue: UILabel!
    @IBOutlet weak var buttonDelete: UIButton!
    @IBOutlet weak var constraintTop: NSLayoutConstraint!
    @IBOutlet weak var constraintBottom: NSLayoutConstraint!
    var viewModel: AddItemViewModelCell!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func render(title: String, quantity: String, value: Decimal, constraint: (top: CGFloat?, bottom: CGFloat?)? = nil) {
        self.labelTitle.text = title
        self.labelQuantity.text = quantity
        self.labelValue.text = value.asMoney()
        if let top = constraint?.top {
            self.constraintTop.constant = top
        }
        if let bottom = constraint?.bottom {
            self.constraintBottom.constant = bottom
        }
        layoutIfNeeded()
    }
}
