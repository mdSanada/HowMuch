//
//  FirestoneRepository.swift
//  HowMuch
//
//  Created by Matheus D Sanada on 21/10/22.
//

import Foundation
import FirebaseFirestore

class FirestoreRepository {
    static public let shared = FirestoreRepository()
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
        self.user = db.collection(FirestoreConsts.Collections.users).document("JPJGimqm0vk6P5zvYE35")
        self.budgets = user.collection(FirestoreConsts.Collections.budgets)
        self.consumption = user.collection(FirestoreConsts.Collections.consumption)
        self.ingredients = user.collection(FirestoreConsts.Collections.ingredients)
        self.materials = user.collection(FirestoreConsts.Collections.materials)
        self.sales = user.collection(FirestoreConsts.Collections.sales)
        self.taxes = user.collection(FirestoreConsts.Collections.taxes)
    }
    
    public func fetchAll() {
        let source = FirestoreSource.cache
        getProfile(source: source)
        getAllSales(source: source)
        getAllTaxes(source: source)
        getAllMaterials(source: source)
        getAllIngredients(source: source)
        getAllConsumption(source: source)
        getAllBudget(source: source)
    }
    
    public func getProfile(source: FirestoreSource) {
        user.getDocument(source: source) { document, error in
            if let document = document {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("🔥 \(dataDescription)")
            } else {
                print("Does not exist")
            }
        }
    }
    
    public func getAllSales(source: FirestoreSource) {
        sales.getDocuments(source: source) { query, error in
            if let query = query {
                let data = query.documents.compactMap{ $0.data().data }
                let response = data.map { $0.map(to: SaleModel.self) }.compactMap { $0 }
                print(response)
            } else {
                print("Does not exist")
            }
        }
    }
    
    public func getAllTaxes(source: FirestoreSource) {
        taxes.getDocuments(source: source) { query, error in
            if let query = query {
                query.documents.forEach { document in
                    let data = query.documents.compactMap{ $0.data().data }
                    let response = data.map { $0.map(to: TaxeModel.self) }.compactMap { $0 }
                    print(response)
                }
            } else {
                print("Does not exist")
            }
        }
    }

    public func getAllMaterials(source: FirestoreSource) {
        materials.getDocuments(source: source) { query, error in
            if let query = query {
                query.documents.forEach { document in
                    let data = query.documents.compactMap{ $0.data().data }
                    let response = data.map { $0.map(to: MaterialModel.self) }.compactMap { $0 }
                    print(response)
                }
            } else {
                print("Does not exist")
            }
        }
    }

    public func getAllIngredients(source: FirestoreSource) {
        ingredients.getDocuments(source: source) { query, error in
            if let query = query {
                query.documents.forEach { document in
                    let data = query.documents.compactMap{ $0.data().data }
                    let response = data.map { $0.map(to: IngredientsModel.self) }.compactMap { $0 }
                    print(response)
                }
            } else {
                print("Does not exist")
            }
        }
    }

    public func getAllConsumption(source: FirestoreSource) {
        consumption.getDocuments(source: source) { query, error in
            if let query = query {
                query.documents.forEach { document in
                    let data = query.documents.compactMap{ $0.data().data }
                    let response = data.map { $0.map(to: ConsumptionModel.self) }.compactMap { $0 }
                    print(response)
                }
            } else {
                print("Does not exist")
            }
        }
    }

    public func getAllBudget(source: FirestoreSource) {
        budgets.getDocuments(source: source) { query, error in
            if let query = query {
                query.documents.forEach { document in
                    let data = query.documents.compactMap{ $0.data().data }
                    let response = data.map { $0.map(to: BudgetModel.self) }.compactMap { $0 }
                    print(response)
                }
            } else {
                print("Does not exist")
            }
        }
    }
    
    public func save(material: MaterialsType, data: Data, completion: @escaping (Bool) -> ()) {
        switch material {
        case .ingredient:
            do {
                let decoded = try JSONDecoder().decode(IngredientsModel.self, from: data)
                Sanada.print("Save \(decoded)")
                completion(true)
            } catch {
                completion(false)
            }
        case .material:
            do {
                let decoded = try JSONDecoder().decode(MaterialModel.self, from: data)
                Sanada.print("Save \(decoded)")
                completion(true)
            } catch {
                completion(false)
            }
        case .taxes:
            do {
                let decoded = try JSONDecoder().decode(TaxeModel.self, from: data)
                Sanada.print("Save \(decoded)")
                completion(true)
            } catch {
                completion(false)
            }
        case .consumption:
            do {
                let decoded = try JSONDecoder().decode(ConsumptionModel.self, from: data)
                Sanada.print("Save \(decoded)")
                completion(true)
            } catch {
                completion(false)
            }
        }
    }

    public func update(uuid: FirestoreId, material: MaterialsType, data: Data, completion: @escaping (Bool) -> ()) {
        switch material {
        case .ingredient:
            do {
                let decoded = try JSONDecoder().decode(IngredientsModel.self, from: data)
                Sanada.print("Save \(decoded)")
                completion(true)
            } catch {
                completion(false)
            }
        case .material:
            do {
                let decoded = try JSONDecoder().decode(MaterialModel.self, from: data)
                Sanada.print("Save \(decoded)")
                completion(true)
            } catch {
                completion(false)
            }
        case .taxes:
            do {
                let decoded = try JSONDecoder().decode(TaxeModel.self, from: data)
                Sanada.print("Save \(decoded)")
                completion(true)
            } catch {
                completion(false)
            }
        case .consumption:
            do {
                let decoded = try JSONDecoder().decode(ConsumptionModel.self, from: data)
                Sanada.print("Save \(decoded)")
                completion(true)
            } catch {
                completion(false)
            }
        }
    }

    public func fetch() {
        // Firebase documentation
//        let docRef = db.collection("cities").document("BJ")
//
//        docRef.getDocument(as: String.self) { result in
//            // The Result type encapsulates deserialization errors or
//            // successful deserialization, and can be handled as follows:
//            //
//            //      Result
//            //        /\
//            //   Error  City
//            switch result {
//            case .success(let city):
//                // A `City` value was successfully initialized from the DocumentSnapshot.
//                print("City: \(city)")
//            case .failure(let error):
//                // A `City` value could not be initialized from the DocumentSnapshot.
//                print("Error decoding city: \(error)")
//            }
//        }
    }
}
