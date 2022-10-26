//
//  MaterialsViewController.swift
//  SNMedicalTreatment
//
//  Created by Matheus D Sanada on 27/09/22.
//

import UIKit
import RxSwift
import RxCocoa

class MaterialsViewController: UIViewController {
    @IBOutlet weak var tableMaterials: UITableView!
    let segmentItems = MaterialsType.allCases.map { $0.rawValue }
    var segmentMaterials: UISegmentedControl?
    
    weak var delegate: MaterialsProtocol?
    fileprivate let searchText = PublishSubject<String>()
    private let searchController = UISearchController()
    private var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        configureBindings()
        configureTable()
    }
    
    private func configureViews() {
        segmentMaterials = UISegmentedControl(items: segmentItems)
        segmentMaterials?.selectedSegmentIndex = 0
        segmentMaterials?.addTarget(self, action: #selector(segmentControl(_:)), for: .valueChanged)
    }
    
    @objc func segmentControl(_ segmentedControl: UISegmentedControl) {
        let index = segmentedControl.selectedSegmentIndex
        let stringType = segmentItems[index]
        guard let material = MaterialsType(rawValue: stringType) else { return }
        
        switch material {
        case .ingredient:
            break
        case .material:
            break
        case .taxes:
            break
        case .consumption:
            break
        }
        
        tableMaterials.reloadData()
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
    
    private func configureTable() {
        tableMaterials.register(type: MaterialTableViewCell.self)
        tableMaterials.delegate = self
        tableMaterials.dataSource = self
        
        if #available(iOS 15.0, *) {
            tableMaterials.sectionHeaderTopPadding = 0
        }
    }
    
    private func filter(text: String) {
        if text.isEmpty {
            print("Will not filter")
        } else {
            print("Will filter: \(text)")
        }
    }
    @IBAction func actionAdd(_ sender: Any) {
        guard let index = segmentMaterials?.selectedSegmentIndex else { return }
        let stringType = segmentItems[index]
        guard let material = MaterialsType(rawValue: stringType) else { return }
        delegate?.create(type: material)
    }
}

extension MaterialsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        searchText.onNext(text)
    }
}

extension MaterialsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let segmentMaterials = segmentMaterials else { return nil }
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        view.addSubview(segmentMaterials)
        segmentMaterials.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.leading.trailing.greaterThanOrEqualToSuperview().priority(.low)
            make.top.bottom.equalToSuperview()
            make.bottom.equalToSuperview().inset(10)
            make.height.equalTo(31)
        }

        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MaterialTableViewCell = tableView.dequeueReusableCell(indexPath)
        cell.render(title: segmentMaterials!.titleForSegment(at: segmentMaterials!.selectedSegmentIndex) ?? "erro",
                    quantity: "unidades",
                    price: Decimal(segmentMaterials!.selectedSegmentIndex))
        
        return cell
    }
}
