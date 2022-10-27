//
//  MaterialCreateViewController.swift
//  HowMuch
//
//  Created by Matheus D Sanada on 24/10/22.
//

import UIKit
import RxSwift
import RxCocoa
import RxSwiftExt

class MaterialCreateViewController: SNViewController<MaterialCreateStates, MaterialCreateViewModel> {
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var createTable: UITableView!
    @IBOutlet weak var buttonComplete: UIButton!
    
    var type: MaterialsType?
    var itens: [CreateDTO] = [] {
        didSet {
            createTable.reloadData()
        }
    }
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTable()
        viewModel?.type.onNext(type)
    }
    
    override func configureViews() {
        super.configureViews()
        guard let type = type else {
            dismiss(animated: true)
            return
        }
        labelTitle.text = type.newTitle()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        didDisappear()
        viewModel?.clean()
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
    
    @IBAction func actionSave(_ sender: Any) {
        viewModel?.complete()
        self.dismiss(animated: true, completion: nil)
    }
    
    private func didDisappear() {
        itens = []
    }
    
    override func render(states: MaterialCreateStates) {
        switch states {
        case .success(let string):
            break
        case .loading(let bool):
            break
        case .error(let string):
            break
        case .button(let enabled):
            buttonComplete.isEnabled = enabled
        case .configure(let itens):
            self.itens = itens
        }
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
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let item = itens[section]
        return item.showTitle ? item.section : nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = itens[indexPath.section]
        let row = item.itens[indexPath.row]
        
        switch row {
        case .text(let viewModel):
            let cell: TextFieldTableViewCell = tableView.dequeueReusableCell(indexPath)
            cell.render(constraint: (top: indexPath.row == 0 ? 0 : nil,
                                     bottom: indexPath.row == (item.itens.count - 1) ? 0 : nil))
            viewModel.completion = self.viewModel?.completion
            cell.configureError(validate: .equalMore(count: 1))
            cell.bind(viewModel: viewModel)

            return cell
        default:
            return UITableViewCell()
        }
    }
}
