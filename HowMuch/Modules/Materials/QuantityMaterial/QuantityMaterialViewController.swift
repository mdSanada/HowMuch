//
//  QuantityViewController.swift
//  HowMuch
//
//  Created by Matheus D Sanada on 02/11/22.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

protocol QuantityMaterialProtocol: AnyObject {
    func pushAdded(type: MaterialsType, quantity: QuantityModel)
    func popToRoot()
}

class QuantityMaterialViewController: SNViewController<QuantityMaterialStates, QuantityMaterialViewModel> {
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var labelValue: UILabel!

    @IBOutlet weak var labelFieldTitle: UILabel!
    @IBOutlet weak var fieldValue: UITextField!
    @IBOutlet weak var buttonMenu: UIButton!
    
    @IBOutlet weak var buttonSave: UIButton!
    
    weak var delegate: QuantityMaterialProtocol? = nil
    weak var selectDelegate: DidSelectMaterialProtocol? = nil
    private var didSelectMenu: String = ""
    private var disposeBag = DisposeBag()
    
    var type: MaterialsType? = nil {
        didSet {
            guard let type = type else { return }
            configureView(type)
        }
    }
    
    var extractedField: Double? {
        get {
            guard let type = type else { return nil }
            switch type {
            case .ingredient, .material:
                return fieldValue.text?.numberInputFormatting()
            case .taxes, .consumption:
                return 1
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureField()
        viewModel?.didLoad.onNext(())
        title = "Adicionar"
        buttonSave.isEnabled = false
        buttonSave.backgroundColor = UIColor.lightGray
    }
    
    override func render(states: QuantityMaterialStates) {
        switch states {
        case .didLoad(let materialsType):
            self.type = materialsType
        }
    }
    
    override func configureBindings() {
        self.view.rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            })
            .disposed(by: disposeBag)
    }
    
    private func configureMenu(actions: [String: String]) {
        var children: [UIAction] = []
        actions.forEach { title in
            let action = UIAction(title: title.value) { [weak self] (action) in
                self?.buttonMenu.setTitle(action.title, for: .normal)
                self?.didSelectMenu = title.key
           }
            children.append(action)
        }

        let menu = UIMenu(options: .displayInline,
                          children: children)
        buttonMenu.menu = menu
        buttonMenu.showsMenuAsPrimaryAction = true
    }
    
    private func configureView(_ type: MaterialsType?) {
        guard let type = type else { return }
        switch type {
        case .material(let material):
            guard let name = material?.name,
                  let quantity = material?.quantity,
                  let measurement = material?.measurement,
                  let cost = material?.cost else { return }
            
            let measure = MeasureType.init(rawValue: material?.measurement ?? "")
            let defaultValue = measure?.defaultValue()
            didSelectMenu = defaultValue?.key ?? ""
            buttonMenu.setTitle(measure?.defaultValue().value, for: .normal)
            let actions = MeasuresHelper.shared.select(from: measure ?? .unit).map { $0.mesure }
            configureMenu(actions: MeasureType.dict(from: actions))
            
            configureHeader(title: name,
                            description: "\(quantity) \(measurement)",
                            value: Decimal(cost).asMoney())
        case .ingredient(let ingredient):
            guard let name = ingredient?.name,
                  let quantity = ingredient?.quantity,
                  let measurement = ingredient?.measurement,
                  let cost = ingredient?.cost else { return }
            let measure = MeasureType.init(rawValue: ingredient?.measurement ?? "")
            let defaultValue = measure?.defaultValue()
            didSelectMenu = defaultValue?.key ?? ""
            buttonMenu.setTitle(measure?.defaultValue().value, for: .normal)
            let actions = MeasuresHelper.shared.select(from: measure ?? .unit).map { $0.mesure }
            configureMenu(actions: MeasureType.dict(from: actions))

            configureHeader(title: name,
                            description: "\(quantity) \(measurement)",
                            value: Decimal(cost).asMoney())
        case .taxes(let taxes):
            guard let name = taxes?.name,
                  let description = taxes?.taxeDescription,
                  let cost = taxes?.cost else { return }
            buttonSave.isEnabled = true
            buttonSave.backgroundColor = UIColor.accent
            fieldValue.isHidden = true
            labelFieldTitle.isHidden = true
            
            let measure = MeasureType.init(rawValue: taxes?.measurement ?? "")
            let defaultValue = measure?.defaultValue()
            didSelectMenu = defaultValue?.key ?? ""
            buttonMenu.setTitle(measure?.defaultValue().value, for: .normal)
            let actions = MeasuresHelper.shared.select(from: measure ?? .unit).map { $0.mesure }
            configureMenu(actions: MeasureType.dict(from: actions))

            configureHeader(title: name,
                            description: description,
                            value: cost.asString().percentFormatting())
        case .consumption(let consumption):
            guard let name = consumption?.name,
                  let _consumption = consumption?.consumption,
                  let level = consumption?.level  else { return }
            buttonSave.isEnabled = true
            buttonSave.backgroundColor = UIColor.accent
            fieldValue.isHidden = true
            labelFieldTitle.isHidden = true
            
            let measure = MeasureType.init(rawValue: consumption?.measurement ?? "")
            let defaultValue = measure?.defaultValue()
            didSelectMenu = defaultValue?.key ?? ""
            buttonMenu.setTitle(measure?.defaultValue().value, for: .normal)
            let actions = MeasuresHelper.shared.select(from: measure ?? .unit).map { $0.mesure }
            configureMenu(actions: MeasureType.dict(from: actions))

            configureHeader(title: name,
                            description: _consumption,
                            value: level)
        }
    }
    
    private func configureHeader(title: String, description: String, value: String) {
        labelTitle.text = title
        labelDescription.text = description
        labelValue.text = value
    }
    
    private func configureField() {
        labelFieldTitle.text = "Quantidade"
        fieldValue.placeholder = "Quantidade"
        fieldValue.keyboardType = .numberPad
        fieldValue.delegate = self
        fieldValue.font = UIFont.systemFont(ofSize: 17, weight: .regular)
    }
    
    @IBAction func actionAdd(_ sender: Any) {
        guard let type = type, let value = extractedField else { return }
        let quantity: QuantityModel = ["quantity": value, "type": didSelectMenu]
        selectDelegate?.didSelect(type: type, quantity: quantity)
        delegate?.pushAdded(type: type, quantity: quantity)
    }
}

extension QuantityMaterialViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let oldText = textField.text else { return false }
        guard lenght(textField: textField, range: range, string: string) else {
            return false
        }
        if string.isEmpty {
            buttonSave.isEnabled = false
            buttonSave.backgroundColor = UIColor.lightGray
            let oldDigits = textField.text?.digitsAndPonctuation
            textField.text = String(oldDigits?.dropLast() ?? "")
        } else {
            let newNumber = (oldText as NSString).replacingCharacters(in: range, with: string).digitsAndPonctuation
            textField.text =  newNumber
            buttonSave.isEnabled = true
            buttonSave.backgroundColor = UIColor.accent
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
