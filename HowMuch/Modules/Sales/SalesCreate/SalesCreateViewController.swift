//
//  SalesCreateViewController.swift
//  HowMuch
//
//  Created by Matheus D Sanada on 24/10/22.
//

import UIKit

class SalesCreateViewController: UIViewController {
    @IBOutlet weak var createTable: UITableView!
    @IBOutlet weak var buttonComplete: UIButton!
    weak var delegate: MyReceiptProtocol? = nil
    var itens: [CreateDTO] = CreateDTO.sales() {
        didSet {
            for item in itens {
                item.itens.forEach { type in
                    switch type {
                    case .image:
                        print("image")
                    case .text(let viewModel):
                        viewModels.append(viewModel)
                    case .item(let viewModel):
                        viewModels.append(viewModel)
                    }
                }
            }
        }
    }
    
    // Change to View Model
    var viewModels: [CellViewModel] = []
    var result: [String: Any] = [:] {
        didSet {
            Sanada.print(result)
        }
    }
    
    func completion(_ item: KeyValue?, _ menu: KeyValue?) {
        if let item = item {
            if let dict = (result[item.key] as? Dictionary<String, Any>),
               let value = (item.value as? Dictionary<String, Any>) {
                result[item.key] = dict.merging(value) { (_, new) in new }
            } else if let value = (item.value as? [Dictionary<String, Any>]) {
                if var dict = (result[item.key] as? [Dictionary<String, Any>]) {
                    dict.append(contentsOf: value)
                    result[item.key] = dict
                } else {
                    var dict: [Dictionary<String, Any>] = []
                    dict.append(contentsOf: value)
                    result[item.key] = dict
                }
            } else {
                result[item.key] = item.value
            }
        }
        
        if let menu = menu {
            result[menu.key] = menu.value
        }
    }
    
    
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
        result = [:]

        itens.forEach { item in
            item.itens.forEach { _item in
                switch _item {
                case .item(let viewModel):
                    viewModel.complete()
                case .text(let viewModel):
                    viewModel.complete()
                default:
                    break
                }
            }
        }
//        viewModels.forEach { viewModel in
//            viewModel.complete()
//        }
        //        self.dismiss(animated: true, completion: nil)
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
            viewModel.completion = completion
            cell.bind(viewModel: viewModel)
            return cell
        case .item(let viewModel):
            guard let type = viewModel.type else { return UITableViewCell() }
            switch type {
            case .item:
                let cell: AddItemTableViewCell = tableView.dequeueReusableCell(indexPath)
                viewModel.completion = completion
                cell.bind(viewModel: viewModel,
                          index: (section: indexPath.section, row: indexPath.row))
                cell.delegate = self
                return cell
            case .add:
                let type = MaterialsType.fromSection(item.section)
                let cell: AddButtonFooterTableViewCell = tableView.dequeueReusableCell(indexPath)
                cell.render(title: viewModel.title ?? "Adicionar") { [weak self] in
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
                let item = CreateItemModel(title: SaleModel.from(material: material),
                                           itemType: .item(type, quantity: quantity))
                let viewModel = AddItemViewModelCell(item: item)
                itens[index].itens.insert(.item(viewModel), at: 0)
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
