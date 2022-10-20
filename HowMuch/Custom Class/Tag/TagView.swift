//
//  TagView.swift
//  SNMedicalTreatment
//
//  Created by Matheus D Sanada on 28/09/22.
//

import UIKit

@IBDesignable
class TagView: UIView {
    @IBOutlet var view: UIView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBInspectable var eventTag: Int = 0 {
        didSet {
            setupTag(EventTag(rawValue: eventTag) ?? .daily)
        }
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)!
        commonInit()
        setupTag(EventTag(rawValue: eventTag) ?? .daily)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        setupTag(EventTag(rawValue: eventTag) ?? .daily)
    }
    
    func setupTag(_ tag: EventTag) {
        view.backgroundColor = tag.color(alpha: 0.2)
        labelTitle.text = tag.title()
        view.layoutIfNeeded()
    }
    
    private func commonInit() {
        setup()
        view.layer.cornerRadius = view.bounds.height / 2
        view.layer.masksToBounds = true
        view.layoutIfNeeded()
    }
    
    private func setup() {
        Bundle.main.loadNibNamed(
            "TagView", owner: self, options: nil
        )
        addSubview(view)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight]
    }
    
    
}
