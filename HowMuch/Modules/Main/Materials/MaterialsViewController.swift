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
    weak var delegate: MaterialsProtocol?
    fileprivate let searchText = PublishSubject<String>()
    private let searchController = UISearchController()
    private var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        configureBindings()
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
            print("Will not filter")
        } else {
            print("Will filter: \(text)")
        }
    }
}

extension MaterialsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        searchText.onNext(text)
    }
}
