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

class MyReceiptViewController: UIViewController {
    @IBOutlet weak var tableReceipt: UITableView!
    
    weak var delegate: MyReceiptProtocol?
    fileprivate let searchText = PublishSubject<String>()
    private let searchController = UISearchController()
    private var disposeBag = DisposeBag()
    
    var array: ReceiptsModel = .mock()
    var filtered: ReceiptsModel = [] {
        didSet {
            tableReceipt.reloadData()
        }
    }
    
    deinit {
        Sanada.print("Deinitializing \(self)")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        configureBindings()
        configureTable()
    }
    
    private func configureTable() {
        filtered = array
        tableReceipt.register(type: ReceiptTableViewCell.self)
        tableReceipt.delegate = self
        tableReceipt.dataSource = self
    }
                                  
    @objc func buttonAction(_ sender: UIButton!) {
        print("Button tapped")
    }
        
    private func configureBindings() {
        searchText
            .distinctUntilChanged()
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] text in
                self?.filter(text: text)
            })
            .disposed(by: disposeBag)
    }
    
    private func filter(text: String) {
        if text.isEmpty {
            filtered = array
        } else {
            filtered = array.filter({ $0.title.lowercased().contains(text.lowercased()) })
        }
    }
    @IBAction func addSale(_ sender: Any) {
        let storyboard = UIStoryboard(name: "SaleStoryboard", bundle: nil)
        let controller = storyboard.instantiateViewController(identifier: "SaleCreate") as? SalesCreateViewController
        navigationController?.present(controller!, animated: true)
    }
}

extension MyReceiptViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "SaleStoryboard", bundle: nil)
        let controller = storyboard.instantiateViewController(identifier: "SaleDetailed") as? SaleDetailedViewController
        navigationController?.present(controller!, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtered.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ReceiptTableViewCell = tableView.dequeueReusableCell(indexPath)
        let item = filtered[indexPath.row]
        cell.render(image: item.image,
                    title: item.title,
                    description: item.description,
                    value: item.value)
        return cell
    }
}

extension MyReceiptViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        searchText.onNext(text)
    }
}
