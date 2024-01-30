//
//  FirebaseManager.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/01/29.
//

import Foundation
import Firebase
import FirebaseCore
import Combine
import FirebaseFirestoreSwift

struct FirebaseManager {
    init() {
        if FirebaseApp.app() == nil {
          FirebaseApp.configure()
        }
    }
    
    func createData<T: Uploadable>(to collection: String, data: T) {
        Firestore.firestore().collection(collection).document(data.id.uuidString).setData(data.dataIntoDictionary())
    }

    func readQueryData<T: Decodable>(from collection: String, query: Filter, orderBy: String, descending: Bool, limit: Int) -> Future<[T], MinimoError> {
        return Future { promise in
            Firestore.firestore().collection(collection)
                .whereFilter(query)
                .getDocuments { snapshot, error in
                if let _ = error {
                    promise(.failure(.unknown))
                }
                guard let snapshot else {
                    promise(.failure(.dataNotFound))
                    return
                }
                
                do {
                    let dataArray = try snapshot.documents.reduce(into: []) { $0.append(try $1.data(as: T.self)) }
                    if dataArray.isEmpty {
                        promise(.failure(.dataNotFound))
                    }
                    promise(.success(dataArray))
                } catch {
                    promise(.failure(.decodingError))
                }
            }
        }
    }
    
    func updateData(from collection: String, uuid: UUID, data: [AnyHashable: Any]) {
        Firestore.firestore().collection(collection).document(uuid.uuidString).updateData(data)
    }
    
    func deleteData(from collection: String, uuid: UUID) {
        Firestore.firestore().collection(collection).document(uuid.uuidString).delete()
    }
    
}


