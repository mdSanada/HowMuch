//
//  ACTryAgainViewController.swift
//  AppCare
//
//  Created by sanada on 22/03/22.
//

import Foundation
import UIKit

internal class AlertViewController: SNViewController<AlertViewState, AlertViewModel> {
    @IBOutlet weak var buttonDismiss: UIButton!
    @IBOutlet weak var viewAlert: UIView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var blurEffect: UIVisualEffectView!
    
    @IBOutlet weak var buttonAction: UIButton!
    @IBOutlet weak var buttonCancel: UIButton!

    private var effect: UIVisualEffect?
    var text: (title: String, description: String) = (title: "", description: "")
    private var handler: (() -> ())? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        setTitle(text.title)
        setDescription(text.description)
        effect = blurEffect.effect
        blurEffect.effect = nil
        viewAlert.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Vibration.medium.vibrate()
        animateIn()
    }
    
    internal func setup(handler: @escaping (() -> ())) {
        self.handler = handler
    }
    
    internal func configure(action: (title: String, color: UIColor),
                            dismiss: (title: String, color: UIColor)) {
//        buttonAction.setTitle(action.title, for: .normal)
//        buttonAction.setTitleColor(.white, for: .normal)
//        buttonAction.backgroundColor = action.color
//        buttonCancel.setTitle(dismiss.title, for: .normal)
//        buttonCancel.setTitleColor(.secondaryLabel, for: .normal)
//        buttonCancel.backgroundColor = dismiss.color
    }
    
    private func animateIn() {
        viewAlert.alpha = 0
        viewAlert.isHidden = false
        UIView.animate(withDuration: 0.35 / 2,
                       delay: 0.01, options: .curveEaseIn) {
            self.blurEffect.effect = self.effect
            self.blurEffect.backgroundColor = UIColor.lightGray.withAlphaComponent(0.7)
            self.viewAlert.transform =
                CGAffineTransform.identity.scaledBy(x: 1.1, y: 1.1)
            self.viewAlert.alpha = 1
        } completion: { finished in
            UIView.animate(withDuration: 0.3 / 2, animations: {
                self.viewAlert.transform = CGAffineTransform.identity
                self.viewAlert.alpha = 1
            })
        }
    }
    
    private func animateOut(handler: (() -> ())? = nil) {
        UIView.animate(withDuration: 0.35 / 2,
                       delay: 0.01, options: .curveEaseIn) {
            self.blurEffect.effect = nil
            self.viewAlert.transform =
            CGAffineTransform.identity.scaledBy(x: 0.8, y: 0.8)
            self.viewAlert.alpha = 0
            self.blurEffect.alpha = 0
        } completion: { finished in
            self.dismiss(animated: false, completion: handler)
        }
    }

    
    override func configureBindings() {
    }
    
    private func setTitle(_ title: String) {
        labelTitle.text = title
        labelTitle.layoutIfNeeded()
    }
    
    private func setDescription(_ description: String) {
        labelDescription.text = description
        labelDescription.layoutIfNeeded()
    }
    
    override func fetch() {
    }
    
    override func configureViews() {
        self.view.backgroundColor = .systemBackground
        self.labelTitle.textColor = UIColor.label
        self.labelDescription.textColor = UIColor.secondaryLabel
        buttonDismiss.tintColor = UIColor.label
    }

    override func render(states: AlertViewState) {
        switch states {
        case .initial:
            break
        }
    }
    
    @IBAction func finish(_ sender: Any) {
        animateOut()
    }
    
    @IBAction func handleAction(_ sender: Any) {
        animateOut(handler: handler)
    }
}
