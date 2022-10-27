//
//  TextFieldTableViewCell.swift
//  HowMuch
//
//  Created by Matheus D Sanada on 24/10/22.
//

import UIKit
import RxSwift
import RxCocoa

enum TextFieldTableViewCellType {
    case title
    case body
    case menu([String], initial: String, hiddenInput: Bool)
}

class TextFieldTableViewCell: UITableViewCell, TextFieldOutputProtocol {
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var fieldContent: UITextField!
    @IBOutlet weak var constraintTop: NSLayoutConstraint!
    @IBOutlet weak var constraintBottom: NSLayoutConstraint!
    @IBOutlet weak var buttonMenu: UIButton!
    var viewModel: TextFieldViewModelCell?
    private var disposeBag = DisposeBag()
    var validateSubject = PublishSubject<Validator>()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        fieldContent.rx.text
            .changed
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] text in
                self?.viewModel?.valueDidChange(text)
            })
            .disposed(by: disposeBag)
        
//        fieldContent.rx
//            .text
//            .changed
//            .map { [weak self] text in
//                return (text?.count ?? 0) >= 1
//            }
//            .subscribe(onNext: {[weak self] (valid) in
//                self?.viewModel?.isValid.onNext(valid)
//            })
//            .disposed(by: disposeBag)
//        
//        fieldContent.rx
//            .text
//            .changed
//            .filter { [weak self] text in
//                return (text?.count ?? 0) >= 1
//            }
//            .map { [weak self] text in
//                return (text?.count ?? 0) >= 1
//            }
//            .subscribe(onNext: {[weak self] (valid) in
//                self?.viewModel?.isValid.onNext(valid)
//            })
//            .disposed(by: disposeBag)

        
        fieldContent.rx
            .text
            .changed
            .withLatestFrom(validateSubject, resultSelector: {(text: $0, validator: $1)})
            .map { [weak self] result in
                result.validator.validate(result.text ?? "")
            }
            .subscribe(onNext: {[weak self] (valid) in
                self?.viewModel?.isValid.onNext(valid)
            })
            .disposed(by: disposeBag)

        fieldContent.rx
            .text
            .changed
            .withLatestFrom(validateSubject, resultSelector: {(text: $0, validator: $1)})
            .filter { [weak self] result in
                result.validator.validate(result.text ?? "")
            }
            .map { [weak self] result in
                result.validator.validate(result.text ?? "")
            }
            .subscribe(onNext: {[weak self] (valid) in
                self?.viewModel?.isValid.onNext(valid)
            })
            .disposed(by: disposeBag)
        
//        fieldContent.rx
//            .controlEvent(.editingDidEnd)
//            .map { [weak self] _ in validate.validate(self?.fieldContent.text ?? "") }
//            .subscribe(onNext: {[weak self] (valid) in
//                self?.subscribeEventField(valid)
//            })
//            .disposed(by: disposeBag)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func bind(viewModel: TextFieldViewModelCell) {
        self.viewModel = viewModel
        self.viewModel?.output = self
        self.viewModel?.awake()
    }

    func configure(type: TextFieldTableViewCellType,
                   title: String,
                   placeholder: String,
                   keyboard: UIKeyboardType) {
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
            viewModel?.menuDidChange(initial)
            configureMenu(actions: actions)
        }
        labelTitle.text = title
        fieldContent.placeholder = placeholder
        fieldContent.keyboardType = keyboard
    }

    func configureError(validate: Validator) {
        validateSubject.onNext(validate)
    }
    
//    private func subscribeEventField(_ isValid: Bool) {
//        viewModel?.isValid.onNext(isValid)
//    }

    public func render(constraint: (top: CGFloat?, bottom: CGFloat?)? = nil) {
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
                self?.viewModel?.menuDidChange(action.title)
           }
            children.append(action)
        }

        let menu = UIMenu(options: .displayInline,
                          children: children)
        buttonMenu.menu = menu
        buttonMenu.showsMenuAsPrimaryAction = true
    }
}
