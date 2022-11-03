//
//  AddButtonFooterTableViewCell.swift
//  HowMuch
//
//  Created by Matheus D Sanada on 24/10/22.
//

import UIKit

class AddButtonFooterTableViewCell: UITableViewCell {
    @IBOutlet weak var buttonAdd: UIButton!
    var action: (() -> Void)? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func render(title: String, action: @escaping (() -> Void)) {
        buttonAdd.setTitle(title, for: .normal)
        self.action = action
    }
    
    @IBAction func addAction(_ sender: Any) {
        action?()
    }
}
