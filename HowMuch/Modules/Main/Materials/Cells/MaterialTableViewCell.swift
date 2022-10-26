//
//  MaterialTableViewCell.swift
//  HowMuch
//
//  Created by Matheus D Sanada on 25/10/22.
//

import UIKit

class MaterialTableViewCell: UITableViewCell {
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelQuantity: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func render(title: String,
                       quantity: String,
                       price: Decimal) {
        self.labelTitle.text = title
        self.labelQuantity.text = quantity
        self.labelPrice.text = price.asMoney()
    }
    
}
