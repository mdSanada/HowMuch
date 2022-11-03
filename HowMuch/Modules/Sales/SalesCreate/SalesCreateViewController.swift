//
//  SalesCreateViewController.swift
//  HowMuch
//
//  Created by Matheus D Sanada on 24/10/22.
//

import UIKit

class SalesCreateViewController: UIViewController {
    @IBOutlet weak var createTable: UITableView!
    
    weak var delegate: MyReceiptProtocol? = nil
    var itens: [CreateDTO] = CreateDTO.sales()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTable()
        title = "Adicionar"
    }
    
    func configureTable() {
        createTable.register(type: TextFieldTableViewCell.self)
        createTable.register(type: AddItemTableViewCell.self)
        createTable.register(type: AddButtonFooterTableViewCell.self)
        createTable.register(type: AddImageTableViewCell.self)
        createTable.delegate = self
        createTable.dataSource = self
    }
    
    private func create() {
        
    }
    
    @IBAction func actionSave(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension SalesCreateViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return itens.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itens[section].itens.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let item = itens[section]
        return item.showTitle ? item.section : nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = itens[indexPath.section]
        let row = item.itens[indexPath.row]
        
        switch row {
        case .image:
            let cell: AddImageTableViewCell = tableView.dequeueReusableCell(indexPath)
            cell.render(image: nil)
            return cell
        case .text(let viewModel):
            let cell: TextFieldTableViewCell = tableView.dequeueReusableCell(indexPath)
            cell.bind(viewModel: viewModel)
            return cell
        case .item(let model):
            guard let type = model?.itemType else { return UITableViewCell() }
            switch type {
            case .item(let material):
                let cell: AddItemTableViewCell = tableView.dequeueReusableCell(indexPath)
                let quantity = material.quantity.asString(digits: 2, minimum: 0) + " unidades"
                switch material.0 {
                case .ingredient(let ingredient):
                    let title = ingredient?.name ?? ""
                    let value = Decimal((ingredient?.cost ?? 0) * material.quantity)
                    cell.render(title: title, quantity: quantity, value: value.asMoney(), index: (section: indexPath.section, row: indexPath.row))
                case .material(let _material):
                    let title = _material?.name ?? ""
                    let value = Decimal((_material?.cost ?? 0) * material.quantity)
                    cell.render(title: title, quantity: quantity, value: value.asMoney(), index: (section: indexPath.section, row: indexPath.row))
                case .taxes(let taxes):
                    let title = taxes?.name ?? ""
                    let value = (taxes?.cost ?? 0).asString().percentFormatting()
                    cell.render(title: title, quantity: "", value: value, index: (section: indexPath.section, row: indexPath.row))
                case .consumption(let consumption):
                    let title = consumption?.name ?? ""
                    let _consumption = consumption?.consumption ?? ""
                    let nivel = consumption?.level ?? ""
                    cell.render(title: title, quantity: nivel, value: _consumption, index: (section: indexPath.section, row: indexPath.row))
                }
                cell.delegate = self
                return cell
            case .add:
                let type = MaterialsType.fromSection(item.section)
                let cell: AddButtonFooterTableViewCell = tableView.dequeueReusableCell(indexPath)
                cell.render(title: model?.title ?? "Adicionar") { [weak self] in
                    guard let type = type else { return }
                    self?.delegate?.pushSelectMaterial(type: type)
                }
                return cell
            }
        default:
            return UITableViewCell()
        }
    }
}

extension SalesCreateViewController: DidSelectMaterialProtocol {
    func didSelect(type: MaterialsType, quantity: Double) {
        for (index, create) in itens.enumerated() {
            guard let material = MaterialsType.fromSection(create.section) else { continue }
            if material == type {
                let item = CreateItemModel(title: nil, itemType: .item(type, quantity: quantity))
                itens[index].itens.insert(.item(item), at: 0)
                createTable.reloadSections(IndexSet(integer: index), with: .automatic)
                break
            }
            continue
        }
    }
}

extension SalesCreateViewController: DidExcludeItemProtocol {
    func exclude(section: Int, row: Int) {
        itens[section].itens.remove(at: row)
        createTable.reloadSections(IndexSet(integer: section), with: .automatic)
    }
}
