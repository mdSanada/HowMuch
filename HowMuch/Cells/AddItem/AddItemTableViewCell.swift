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
    weak var delegate: DidExcludeItemProtocol? = nil
    var index: (section: Int, row: Int)? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func bind(viewModel: AddItemViewModelCell, index: (section: Int, row: Int)) {
        self.viewModel = viewModel
        self.viewModel?.output = self
        self.viewModel?.awake()
        self.index = index
    }
    
    public func render(constraint: (top: CGFloat?, bottom: CGFloat?)? = nil) {
        if let top = constraint?.top {
            self.constraintTop.constant = top
        }
        if let bottom = constraint?.bottom {
            self.constraintBottom.constant = bottom
        }
        layoutIfNeeded()
    }
    
    @IBAction func actionExclude(_ sender: Any) {
        guard let section = index?.section, let row = index?.row else { return }
        delegate?.exclude(section: section, row: row)
    }
}

extension AddItemTableViewCell: AddItemOutputProtocol {
    
    func configure(title: String, quantity: String, value: String) {
        self.labelTitle.text = title
        self.labelQuantity.text = quantity
        self.labelValue.text = value
        layoutIfNeeded()
    }
    
    func clean() {
        delegate = nil
    }
}
