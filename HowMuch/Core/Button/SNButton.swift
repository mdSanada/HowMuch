//
//  ACButton.swift
//  Sanada
//
//  Created by Matheus D Sanada on 25/03/22.
//

import Foundation
import UIKit

public class SNButton: UIButton {
    private (set) var states: [ButtonState] = []

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator: UIActivityIndicatorView = .init()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = self.titleColor(for: .disabled)
        self.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        return activityIndicator
    }()
    
    private var oldIsEnabled: Bool? = false
    
    struct ButtonState {
        var state: UIControl.State
        var title: String?
        var image: UIImage?
    }
    
    public override var isEnabled: Bool {
        didSet {
            setupButton()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        self.addTarget(self, action: #selector(didTap), for: .touchUpInside)
        self.layer.cornerRadius = 6
        setupButton()
    }
    
    @objc func didTap() {
        self.superview?.endEditing(true)
    }
    
    private func setupButton() {
        setTitleColor(.label, for: .normal)
        // TODO: - Change Colors
//        setTitleColor(.secondatyLabel, for: .disabled)
        setTitleColor(.label.withAlphaComponent(0.5), for: .highlighted)
        
        if isEnabled {
            backgroundColor = .accent
            layer.borderWidth = 0
            layer.borderColor = UIColor.clear.cgColor
        } else {
//            backgroundColor = .secondatyLabel
            layer.borderWidth = 0
            layer.borderColor = UIColor.clear.cgColor
        }
    }
    
    public var isLoading: Bool = false {
        didSet {
            if oldValue != isLoading {
                isLoading ? showLoading() : hideLoading()
            }
        }
    }

    func showLoading() {
        oldIsEnabled = isEnabled
        DispatchQueue.main.async { [weak self] in
            self?.isUserInteractionEnabled = false
            self?.activityIndicator.startAnimating()
            var states: [ButtonState] = []
            for state in [UIControl.State.disabled] {
                let buttonState = ButtonState(
                    state: state,
                    title: self?.title(for: state),
                    image: self?.image(for: state)
                )
                states.append(buttonState)
                self?.setTitle("", for: state)
                self?.setImage(.init(), for: state)
            }
            self?.states = states
            self?.isEnabled = false
        }
    }

    func hideLoading() {
        DispatchQueue.main.async { [weak self] in
            self?.isUserInteractionEnabled = true
            self?.activityIndicator.stopAnimating()
            guard let states = self?.states else {
                return
            }
            for state in states {
                self?.setTitle(state.title, for: state.state)
                self?.setImage(state.image, for: state.state)
            }
            self?.isEnabled = self?.oldIsEnabled ?? false
        }
    }
}
