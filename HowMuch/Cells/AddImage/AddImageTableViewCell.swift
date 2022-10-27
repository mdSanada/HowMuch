//
//  AddImageTableViewCell.swift
//  HowMuch
//
//  Created by Matheus D Sanada on 25/10/22.
//

import UIKit

class AddImageTableViewCell: UITableViewCell {
    @IBOutlet weak var imageBackground: UIImageView!
    var viewModel: AddImageViewModelCell!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    public func render(image: UIImage?) {
        imageBackground.image = image
    }
}
