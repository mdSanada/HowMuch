//
//  FirestoneRepository.swift
//  HowMuch
//
//  Created by Matheus D Sanada on 21/10/22.
//

import Foundation
import FirebaseFirestore
import RxSwift

class FirestoreRepository {
    static public let shared = FirestoreRepository()
    private var disposeBag = DisposeBag()
    private let db: Firestore
    private let user: DocumentReference
    private let budgets: CollectionReference
    private let consumption: CollectionReference
    private let ingredients: CollectionReference
    private let materials: CollectionReference
    private let sales: CollectionReference
    private let taxes: CollectionReference
    
    init() {
        self.db = Firestore.firestore()
        self.user = db.collection(FirestoreConsts.Collections.users).document(AuthRepository.shared.token() ?? "")
        self.budgets = user.collection(FirestoreConsts.Collections.budgets)
        self.consumption = user.collection(FirestoreConsts.Collections.consumption)
        self.ingredients = user.collection(FirestoreConsts.Collections.ingredients)
        self.materials = user.collection(FirestoreConsts.Collections.materials)
        self.sales = user.collection(FirestoreConsts.Collections.sales)
        self.taxes = user.collection(FirestoreConsts.Collections.taxes)
        configureListeners()
    }
    
    fileprivate func configureListeners() {
        user.addSnapshotListener { querySnapshot, error in
            guard error == nil else {
                return
            }
            self.getProfile(source: .default) { success in
                guard success else {
                    return
                }
                Sanada.print("Notification warn update profile")
            }
        }

        budgets.addSnapshotListener { querySnapshot, error in
            guard error == nil else {
                return
            }
            self.getAllBudget(source: .default) { success in
                guard success else {
                    return
                }
                Sanada.print("Notification warn update budgets")
            }
        }
        
        sales.addSnapshotListener { querySnapshot, error in
            guard error == nil else {
                return
            }
            self.getAllSales(source: .default) { success in
                guard success else {
                    return
                }
                Sanada.print("Notification warn update sales")
            }
        }

        consumption.addSnapshotListener { querySnapshot, error in
            guard error == nil else {
                return
            }
            self.getAllConsumption(source: .default) { success in
                guard success else {
                    return
                }
                Sanada.print("Notification warn update consumption")
            }
        }

        ingredients.addSnapshotListener { querySnapshot, error in
            guard error == nil else {
                return
            }
            self.getAllIngredients(source: .default) { success in
                guard success else {
                    return
                }
                Sanada.print("Notification warn update ingredients")
            }
        }

        materials.addSnapshotListener { querySnapshot, error in
            guard error == nil else {
                return
            }
            self.getAllMaterials(source: .default) { success in
                guard success else {
                    return
                }
                Sanada.print("Notification warn update materials")
            }
        }
        
        taxes.addSnapshotListener { querySnapshot, error in
            guard error == nil else {
                return
            }
            self.getAllTaxes(source: .default) { success in
                guard success else {
                    return
                }
                Sanada.print("Notification warn update taxes")
            }
        }
    }

    
    public func fetchAll(completion: @escaping (Bool) -> ()) {
        let source = FirestoreSource.default
        let requestList = [getProfile, getAllSales, getAllTaxes, getAllMaterials, getAllIngredients, getAllConsumption, getAllBudget]
        var finishRequests = requestList.map { _ in false }
        let observable = Observable.of(finishRequests)
        requestList.enumerated().forEach { index, request in
            request(source) { [weak self] success in
                finishRequests[index] = success
            }
        }
        
        observable
            .map { $0.allSatisfy { $0 } }
            .subscribe(onNext: { [weak self] _ in
                completion(true)
            })
            .disposed(by: disposeBag)
//        getProfile(source: source)
//        getAllSales(source: source)
//        getAllTaxes(source: source)
//        getAllMaterials(source: source)
//        getAllIngredients(source: source)
//        getAllConsumption(source: source)
//        getAllBudget(source: source)
    }
    
    public func getProfile(source: FirestoreSource, completion: @escaping (Bool) -> ()) {
        user.getDocument(source: source) { document, error in
            if let document = document {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    public func getAllSales(source: FirestoreSource, completion: @escaping (Bool) -> ()) {
        sales.getDocuments(source: source) { query, error in
            if let query = query {
                let data = query.documents.compactMap { response -> Data? in
                    var dict = response.data()
                    dict["firestoreId"] = response.documentID
                    return dict.data
                }
                let response = data.map { $0.map(to: SaleModel.self) }.compactMap { $0 }
                FirestoreInteractor.shared.sales = response
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    public func getAllTaxes(source: FirestoreSource, completion: @escaping (Bool) -> ()) {
        taxes.getDocuments(source: source) { query, error in
            if let query = query {
                query.documents.forEach { document in
                    let data = query.documents.compactMap { response -> Data? in
                        var dict = response.data()
                        dict["firestoreId"] = response.documentID
                        return dict.data
                    }
                    let response = data.map { $0.map(to: TaxeModel.self) }.compactMap { $0 }
                    FirestoreInteractor.shared.taxes = response
                    completion(true)
                }
            } else {
                completion(false)
            }
        }
    }
    
    public func getTaxes(source: FirestoreSource, id: FirestoreId, completion: @escaping (TaxeModel?) -> ()) {
        ingredients.document(id).getDocument(source: source) { document, error in
            if let document = document {
                var dict = document.data()
                dict?["firestoreId"] = id
                let response = dict?.data?.map(to: TaxeModel.self)
                completion(response)
            } else {
                completion(nil)
            }
        }
    }
    
    public func deleteTaxes(id: FirestoreId, completion: @escaping (Bool) -> ()) {
        taxes.document(id).delete { error in
            guard error == nil else {
                completion(false)
                return
            }
            completion(true)
        }
    }

    public func getAllMaterials(source: FirestoreSource, completion: @escaping (Bool) -> ()) {
        materials.getDocuments(source: source) { query, error in
            if let query = query {
                query.documents.forEach { document in
                    let data = query.documents.compactMap { response -> Data? in
                        var dict = response.data()
                        dict["firestoreId"] = response.documentID
                        return dict.data
                    }
                    let response = data.map { $0.map(to: MaterialModel.self) }.compactMap { $0 }
                    FirestoreInteractor.shared.materials = response
                    completion(true)
                }
            } else {
                completion(false)
            }
        }
    }
    
    public func getMaterial(source: FirestoreSource, id: FirestoreId, completion: @escaping (MaterialModel?) -> ()) {
        materials.document(id).getDocument(source: source) { document, error in
            if let document = document {
                var dict = document.data()
                dict?["firestoreId"] = id
                let response = dict?.data?.map(to: MaterialModel.self)
                completion(response)
            } else {
                completion(nil)
            }
        }
    }
    
    public func deleteMaterial(id: FirestoreId, completion: @escaping (Bool) -> ()) {
        materials.document(id).delete { error in
            guard error == nil else {
                completion(false)
                return
            }
            completion(true)
        }
    }

    public func getAllIngredients(source: FirestoreSource, completion: @escaping (Bool) -> ()) {
        ingredients.getDocuments(source: source) { query, error in
            if let query = query {
                query.documents.forEach { document in
                    let data = query.documents.compactMap { response -> Data? in
                        var dict = response.data()
                        dict["firestoreId"] = response.documentID
                        return dict.data
                    }
                    let response = data.map { $0.map(to: IngredientsModel.self) }.compactMap { $0 }
                    FirestoreInteractor.shared.ingredients = response
                    completion(true)
                }
            } else {
                completion(false)
            }
        }
    }
    
    public func getIngredient(source: FirestoreSource, id: FirestoreId, completion: @escaping (IngredientsModel?) -> ()) {
        ingredients.document(id).getDocument(source: source) { document, error in
            if let document = document {
                var dict = document.data()
                dict?["firestoreId"] = id
                let response = dict?.data?.map(to: IngredientsModel.self)
                completion(response)
            } else {
                completion(nil)
            }
        }
    }
    
    public func deleteIngredient(id: FirestoreId, completion: @escaping (Bool) -> ()) {
        ingredients.document(id).delete { error in
            guard error == nil else {
                completion(false)
                return
            }
            completion(true)
        }
    }


    public func getAllConsumption(source: FirestoreSource, completion: @escaping (Bool) -> ()) {
        consumption.getDocuments(source: source) { query, error in
            if let query = query {
                query.documents.forEach { document in
                    let data = query.documents.compactMap { response -> Data? in
                        var dict = response.data()
                        dict["firestoreId"] = response.documentID
                        return dict.data
                    }
                    let response = data.map { $0.map(to: ConsumptionModel.self) }.compactMap { $0 }
                    FirestoreInteractor.shared.consumption = response
                    completion(true)
                }
            } else {
                completion(false)
            }
        }
    }
    
    public func getConsumption(source: FirestoreSource, id: FirestoreId, completion: @escaping (ConsumptionModel?) -> ()) {
        consumption.document(id).getDocument(source: source) { document, error in
            if let document = document {
                var dict = document.data()
                dict?["firestoreId"] = id
                let response = dict?.data?.map(to: ConsumptionModel.self)
                completion(response)
            } else {
                completion(nil)
            }
        }
    }
    
    public func deleteConsumption(id: FirestoreId, completion: @escaping (Bool) -> ()) {
        consumption.document(id).delete { error in
            guard error == nil else {
                completion(false)
                return
            }
            completion(true)
        }
    }


    public func getAllBudget(source: FirestoreSource, completion: @escaping (Bool) -> ()) {
        budgets.getDocuments(source: source) { query, error in
            if let query = query {
                query.documents.forEach { document in
                    let data = query.documents.compactMap { response -> Data? in
                        var dict = response.data()
                        dict["firestoreId"] = response.documentID
                        return dict.data
                    }
                    
                    let response = data.map { $0.map(to: BudgetModel.self) }.compactMap { $0 }
                    FirestoreInteractor.shared.budgets = response
                    completion(true)
                }
            } else {
                completion(false)
            }
        }
    }
    
    public func fetch(material: MaterialsType, completion: @escaping (Bool) -> ()) {
        let source = FirestoreSource.default
        switch material {
        case .ingredient:
            getAllIngredients(source: source, completion: completion)
        case .material:
            getAllMaterials(source: source, completion: completion)
        case .taxes:
            getAllTaxes(source: source, completion: completion)
        case .consumption:
            getAllConsumption(source: source, completion: completion)
        }
    }
    
    public func save(material: MaterialsType, data: Data, completion: @escaping (Bool) -> ()) {
        guard let data = data.dictionary else {
            completion(false)
            return
        }
        switch material {
        case .ingredient:
            ingredients.addDocument(data: data) { error in
                guard error == nil else {
                    completion(false)
                    return
                }
                completion(true)
            }
        case .material:
            materials.addDocument(data: data) { error in
                guard error == nil else {
                    completion(false)
                    return
                }
                completion(true)
            }
        case .taxes:
            taxes.addDocument(data: data) { error in
                guard error == nil else {
                    completion(false)
                    return
                }
                completion(true)
            }
        case .consumption:
            consumption.addDocument(data: data) { error in
                guard error == nil else {
                    completion(false)
                    return
                }
                completion(true)
            }
        }
    }

    public func update(uuid: FirestoreId, material: MaterialsType, data: Data, completion: @escaping (Bool) -> ()) {
        guard let data = data.dictionary else {
            completion(false)
            return
        }
        switch material {
        case .ingredient:
            ingredients.document(uuid).setData(data, merge: true) { error in
                guard error == nil else {
                    completion(false)
                    return
                }
                completion(true)
            }
        case .material:
            materials.document(uuid).setData(data, merge: true) { error in
                guard error == nil else {
                    completion(false)
                    return
                }
                completion(true)
            }
        case .taxes:
            taxes.document(uuid).setData(data, merge: true) { error in
                guard error == nil else {
                    completion(false)
                    return
                }
                completion(true)
            }
        case .consumption:
            consumption.document(uuid).setData(data, merge: true) { error in
                guard error == nil else {
                    completion(false)
                    return
                }
                completion(true)
            }
        }
    }
    
    func save(user: FirestoreId, name: String) {
        db.collection(FirestoreConsts.Collections.users).document(user).setData(["name": name])
    }
}
