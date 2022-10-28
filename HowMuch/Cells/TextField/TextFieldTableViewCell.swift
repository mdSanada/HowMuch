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
    case menu(key: String, actions: [String], initial: String, hiddenInput: Bool)
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
    var textFieldType: TextFieldTypes = .percent

    override func awakeFromNib() {
        super.awakeFromNib()
        fieldContent.delegate = self

        fieldContent.rx.text
            .changed
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] text in
                switch self?.textFieldType {
                case .text:
                    self?.viewModel?.valueDidChange(text)
                case .currency:
                    self?.viewModel?.valueDidChange(text.decimalInputFormatting())
                case .percent:
                    self?.viewModel?.valueDidChange(text.percentInputFormatting())
                case .number:
                    self?.viewModel?.valueDidChange(text.numberInputFormatting())
                default:
                    self?.viewModel?.valueDidChange(text)
                }
            })
            .disposed(by: disposeBag)
        
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
                   initial: String?,
                   textFieldType: TextFieldTypes) {
        switch type {
        case .title:
            labelTitle.font = UIFont.systemFont(ofSize: 28, weight: .bold)
            fieldContent.font = UIFont.systemFont(ofSize: 22, weight: .bold)
            buttonMenu.isHidden = true
        case .body:
            labelTitle.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            fieldContent.font = UIFont.systemFont(ofSize: 17, weight: .regular)
            buttonMenu.isHidden = true
        case .menu(let key, let actions, let initial, let hiddenInput):
            labelTitle.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            fieldContent.font = UIFont.systemFont(ofSize: 17, weight: .regular)
            buttonMenu.isHidden = false
            fieldContent.isUserInteractionEnabled = !hiddenInput
            buttonMenu.setTitle(initial, for: .normal)
            viewModel?.menuDidChange(initial)
            viewModel?.setMenuKey(key)
            configureMenu(actions: actions)
        }
        labelTitle.text = title
        self.textFieldType = textFieldType
        switch textFieldType {
        case .text:
            fieldContent.rx.text.onNext(initial)
        case .currency:
            fieldContent.rx.text.onNext(initial?.currencyInputFormatting())
        case .percent:
            fieldContent.rx.text.onNext(initial?.percentFormatting())
        case .number:
            fieldContent.rx.text.onNext(initial?.numberFormatting())
        }
        fieldContent.placeholder = placeholder
        fieldContent.keyboardType = textFieldType.keyboard()
    }

    func configureError(validate: Validator) {
        validateSubject.onNext(validate)
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

extension TextFieldTableViewCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let oldText = textField.text else { return false }
        switch textFieldType {
        case .currency:
            guard lenght(textField: textField, range: range, string: string) else {
                return false
            }
            if string.isEmpty {
                let oldDigits = textField.text?.digits
                textField.text = String(oldDigits?.dropLast() ?? "").currencyInputFormatting()
            } else {
                let newNumber = (oldText as NSString).replacingCharacters(in: range, with: string).digits
                textField.text = newNumber.currencyInputFormatting()
            }
        case .percent:
            guard lenght(textField: textField, range: range, string: string) else {
                return false
            }
            if string.isEmpty {
                let oldDigits = textField.text?.digits
                textField.text = String(oldDigits?.dropLast() ?? "").percentFormatting()
            } else {
                let newNumber = (oldText as NSString).replacingCharacters(in: range, with: string).digits
                textField.text =  newNumber.percentFormatting()
            }
        case .number:
            guard lenght(textField: textField, range: range, string: string) else {
                return false
            }
            if string.isEmpty {
                
                let oldDigits = textField.text?.digitsAndPonctuation
                textField.text = String(oldDigits?.dropLast() ?? "")
            } else {
                let newNumber = (oldText as NSString).replacingCharacters(in: range, with: string).digitsAndPonctuation
                textField.text =  newNumber
            }
        default:
            return true
        }
        return false
    }
    
    private func lenght(textField: UITextField, range: NSRange, string: String) -> Bool {
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.onlyNumbers().count - substringToReplace.count + string.count
        return count <= 12
    }
}
