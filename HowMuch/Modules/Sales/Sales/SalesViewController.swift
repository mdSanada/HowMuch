//
//  MyReceiptViewController.swift
//  SNMedicalTreatment
//
//  Created by Matheus D Sanada on 10/09/22.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SalesViewController: SNViewController<SalesStates, SalesViewModel> {
    @IBOutlet weak var tableReceipt: UITableView!
    
    weak var delegate: MyReceiptProtocol?
    fileprivate let searchText = PublishSubject<String>()
    private let searchController = UISearchController()
    private var disposeBag = DisposeBag()
    
    var filtered: [SaleDTO] = [] {
        didSet {
            tableReceipt.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        configureTable()
        viewModel?.didLoad.onNext(())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .automatic
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationItem.largeTitleDisplayMode = .never
    }
    
    private func configureTable() {
        tableReceipt.register(type: ReceiptTableViewCell.self)
        tableReceipt.delegate = self
        tableReceipt.dataSource = self
    }
                                  
    @objc func buttonAction(_ sender: UIButton!) {
        print("Button tapped")
    }
        
    override func configureBindings() {
        searchText
            .distinctUntilChanged()
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] text in
                self?.viewModel?.filteredText.onNext(text)
            })
            .disposed(by: disposeBag)
    }
    
    override func render(states: SalesStates) {
        switch states {
        case .didLoad(let sales):
            filtered = sales
        case .filter(let array):
            filtered = array
        }
    }
    
    @IBAction func addSale(_ sender: Any) {
        Vibration.light.vibrate()
        delegate?.presentSaleCreate()
    }
}

extension SalesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = filtered[indexPath.row]
        delegate?.pushSaleDatailed(item: item)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtered.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ReceiptTableViewCell = tableView.dequeueReusableCell(indexPath)
        let item = filtered[indexPath.row]
        
        cell.render(image: nil,
                    title: item.name ?? "",
                    description: item.salesDescription ?? "",
                    value: Decimal(item.unitPrice ?? 0))
        return cell
    }
}

extension SalesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        searchText.onNext(text)
    }
}
