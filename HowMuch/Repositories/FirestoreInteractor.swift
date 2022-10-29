//
//  FirestoreInteractor.swift
//  HowMuch
//
//  Created by Matheus D Sanada on 29/10/22.
//

import Foundation

struct FirestoreInteractor {
    static var shared = FirestoreInteractor()
    
    public var budgets: [BudgetModel] = [] {
        didSet {
            SNNotificationCenter.post(notification: SNNotificationCenter.materials.notification, arguments: ["material": "budgets"])
        }
    }
    public var materials: [MaterialModel] = []{
        didSet {
            SNNotificationCenter.post(notification: SNNotificationCenter.materials.notification, arguments: ["material": MaterialsType.material(nil).title()])
        }
    }
    public var ingredients: [IngredientsModel] = []{
        didSet {
            SNNotificationCenter.post(notification: SNNotificationCenter.materials.notification, arguments: ["material": MaterialsType.ingredient(nil).title()])
        }
    }
    public var taxes: [TaxeModel] = []{
        didSet {
            SNNotificationCenter.post(notification: SNNotificationCenter.materials.notification, arguments: ["material": MaterialsType.taxes(nil).title()])
        }
    }
    public var consumption: [ConsumptionModel] = []{
        didSet {
            SNNotificationCenter.post(notification: SNNotificationCenter.materials.notification, arguments: ["material": MaterialsType.consumption(nil).title()])
        }
    }
    public var sales: [SaleModel] = []{
        didSet {
            SNNotificationCenter.post(notification: SNNotificationCenter.sales.notification, arguments: ["material": "sales"])
        }
    }
        
    public func fetchAll(completion: @escaping (Bool) -> ()) {
        FirestoreRepository.shared.getAllMaterials(source: .default) { success in
            
        }
        
        FirestoreRepository.shared.getAllIngredients(source: .default)  { success in
            
        }
        
        FirestoreRepository.shared.getAllTaxes(source: .default)  { success in
            
        }
        
        FirestoreRepository.shared.getAllConsumption(source: .default)  { success in
            
        }
    }
}
