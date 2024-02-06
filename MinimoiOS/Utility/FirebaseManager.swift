//
//  FirebaseManager.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/01/29.
//

import Foundation
import Combine
import Firebase
import FirebaseCore
import FirebaseFirestoreSwift
import FirebaseStorage

struct FirebaseManager {
    typealias ImageString = (url: String, path: String)
    
    init() {
        if FirebaseApp.app() == nil {
          FirebaseApp.configure()
        }
    }
    
    func createData<T: Uploadable>(to collection: String, data: T) {
        Firestore.firestore().collection(collection).document(data.id.uuidString).setData(data.dataIntoDictionary())
    }
    
    func readUserData(for id: UUID) -> Future<UserDTO, MinimoError> {
        let query = Filter.whereField("id", isEqualTo: id.uuidString)
        return Future { promise in
            Firestore.firestore()
                .collection("users")
                .whereFilter(query)
                .getDocuments { snapshot, error in
                    if let _ = error {
                        promise(.failure(.unknown))
                        return
                    }
                    guard let snapshot else {
                        promise(.failure(.dataNotFound))
                        return
                    }
                    do {
                        let dataArray = try snapshot.documents.reduce(into: []) { $0.append(try $1.data(as: UserDTO.self)) }
                        guard let userData = dataArray.first else {
                            promise(.failure(.dataNotFound))
                            return
                        }
                        promise(.success(userData))
                    } catch {
                        promise(.failure(.decodingError))
                    }
            }
        }
    }
    
    func readSingleData<T: Decodable>(from collection: String, query: Filter) -> Future<T, MinimoError> {
        return Future { promise in
            Firestore.firestore()
                .collection(collection)
                .whereFilter(query)
                .getDocuments { snapshot, error in
                    if let _ = error {
                        promise(.failure(.unknown))
                        return
                    }
                    guard let snapshot else {
                        promise(.failure(.dataNotFound))
                        return
                    }
                    do {
                        let dataArray = try snapshot.documents.reduce(into: []) { $0.append(try $1.data(as: T.self)) }
                        guard let data = dataArray.first else {
                            promise(.failure(.dataNotFound))
                            return
                        }
                        promise(.success(data))
                    } catch {
                        promise(.failure(.decodingError))
                    }
                }
        }
    }

    func readMultipleData<T: Decodable>(from collection: String, query: Filter, orderBy: String, descending: Bool, limit: Int) -> Future<[T], MinimoError> {
        return Future { promise in
            Firestore.firestore()
                .collection(collection)
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
    
    func saveJpegImage(image: UIImage, collection: String, uuid: UUID) -> Future<ImageString, MinimoError> {
        return Future { promise in
            guard let data = image.jpegData(compressionQuality: 0.8) else {
                promise(.failure(.invalidImage))
                return
            }

            let storage = Storage.storage()
            let meta = StorageMetadata()
            meta.contentType = "image/jpeg"
            let path = "\(collection)/\(uuid)/\(UUID().uuidString)"
            let imageReference = storage.reference().child(path)
            imageReference.putData(data, metadata: meta) { _, error in
                if error != nil {
                    promise(.failure(.invalidImage))
                    return
                }
                imageReference.downloadURL { url, _ in
                    guard let url else {
                        promise(.failure(.invalidImage))
                        return
                    }
                    promise(.success((url: "\(url)", path: "\(path).jpeg")))
                }
            }
        }
    }
    
    func deleteImage(path: String) {
        Storage.storage().reference().child(path).delete { _ in }
    }
    
}

