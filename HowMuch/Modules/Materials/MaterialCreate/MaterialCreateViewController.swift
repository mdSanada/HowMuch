//
//  MaterialCreateViewController.swift
//  HowMuch
//
//  Created by Matheus D Sanada on 24/10/22.
//

import UIKit

class MaterialCreateViewController: UIViewController {
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var createTable: UITableView!
    var type: MaterialsType?
    var itens: [CreateDTO] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureTable()
    }
    
    private func configureView() {
        guard let type = type else {
            dismiss(animated: true)
            return
        }
        itens = CreateDTO.materials(type: type)
        labelTitle.text = type.newTitle()
    }
    
    private func configureTable() {
        createTable.register(type: TextFieldTableViewCell.self)
        createTable.register(type: SelectableTableViewCell.self)
        createTable.delegate = self
        createTable.dataSource = self
        
        if #available(iOS 15.0, *) {
            createTable.sectionHeaderTopPadding = 0
        }
    }
    
    private func create() {
        
    }
    
    @IBAction func actionSave(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension MaterialCreateViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return itens.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itens[section].itens.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let item = itens[section]
        return item.showTitle ? 30 : 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let item = itens[section]
        return item.showTitle ? item.section : nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = itens[indexPath.section]
        
        switch item.type {
        case .text:
            let row = item.itens[indexPath.row]
            guard let type = row.type, let title = row.title, let placeholder = row.placeholder else { return UITableViewCell() }
            let cell: TextFieldTableViewCell = tableView.dequeueReusableCell(indexPath)
            cell.render(type: type,
                        title: title,
                        placeholder: placeholder,
                        constraint: (top: indexPath.row == 0 ? 0 : nil,
                                     bottom: indexPath.row == (item.itens.count - 1) ? 0 : nil))
            return cell
        case .selectable:
            let row = item.itens[indexPath.row]
            guard let title = row.title, let menu = row.selectable else { return UITableViewCell() }
            let cell: SelectableTableViewCell = tableView.dequeueReusableCell(indexPath)
            cell.render(title: title, actions: menu)
            return cell
        default:
            return UITableViewCell()
        }
    }
}
