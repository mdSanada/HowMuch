//
//  EventStatusView.swift
//  SNMedicalTreatment
//
//  Created by Matheus D Sanada on 28/09/22.
//

import UIKit

@IBDesignable
class StatusView: UIView {
    @IBOutlet var view: UIView!
    @IBOutlet weak var viewCircle: UIView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var viewSpacer: UIView!
    @IBOutlet weak var viewStatus: UIView!
    @IBOutlet weak var stackView: UIStackView!
    
    @IBInspectable var status: Int = 0 {
        didSet {
            setupStatus(Status(rawValue: status) ?? .current)
        }
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)!
        commonInit()
        setupStatus(Status(rawValue: status) ?? .current)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        setupStatus(Status(rawValue: status) ?? .current)
    }
    
    func setupStatus(_ status: Status) {
        viewStatus.backgroundColor = status.color(alpha: 0.2)
        viewCircle.backgroundColor = status.color()
        labelTitle.text = status.title()
        view.layoutIfNeeded()
    }
    
    func change(direction: StatusDirection) {
        stackView.arrangedSubviews.forEach { stackView.removeArrangedSubview($0)}
        switch direction {
        case .right:
            stackView.addArrangedSubview(viewSpacer)
            stackView.addArrangedSubview(viewStatus)
        case .left:
            stackView.addArrangedSubview(viewStatus)
            stackView.addArrangedSubview(viewSpacer)
        }
        stackView.layoutIfNeeded()
    }
    
    private func commonInit() {
        setup()
    }
    
    private func setup() {
        Bundle.main.loadNibNamed(
            "StatusView", owner: self, options: nil
        )
        addSubview(view)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        viewStatus.layer.cornerRadius = viewStatus.bounds.height / 2
        viewStatus.layer.masksToBounds = true
        viewCircle.layer.cornerRadius = viewCircle.bounds.height / 2
        viewCircle.layer.masksToBounds = true
        viewCircle.layoutIfNeeded()
        view.layoutIfNeeded()
    }
    
    
}
