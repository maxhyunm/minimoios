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
    
    func createData<T: Uploadable>(to collection: Collection, data: T) async throws {
        try await Firestore.firestore().collection(collection.name).document(data.id.uuidString)
            .setData(data.dataIntoDictionary())
    }
    
    func readSingleData<T: Decodable>(from collection: Collection, query: Filter) -> Future<T, MinimoError> {
        return Future { promise in
            Firestore.firestore()
                .collection(collection.name)
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

    func readMultipleData<T: Decodable>(from collection: Collection, query: Filter, orderBy: String, descending: Bool, limit: Int? = nil) -> Future<[T], MinimoError> {
        let ref = Firestore.firestore()
            .collection(collection.name)
            .whereFilter(query)
//            .order(by: orderBy, descending: descending)
//        if let limit {
//            ref.limit(to: limit)
//        }
        return Future { promise in
            ref.getDocuments { snapshot, error in
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
    
    func updateData(from collection: Collection, uuid: UUID, data: [AnyHashable: Any]) async throws {
        try await Firestore.firestore().collection(collection.name).document(uuid.uuidString).updateData(data)
    }
    
    func deleteData(from collection: Collection, uuid: UUID) async throws {
        try await Firestore.firestore().collection(collection.name).document(uuid.uuidString)
            .updateData(collection.fields.reduce(into: [:]) { $0[$1] = FieldValue.delete() })
        try await Firestore.firestore().collection(collection.name).document(uuid.uuidString).delete()
    }
    
    func saveJpegImageAsync(image: UIImage, collection: Collection, uuid: UUID) async throws -> ImageString {
        guard let data = image.jpegData(compressionQuality: 0.8) else {
            throw MinimoError.invalidImage
        }
        let storage = Storage.storage()
        let meta = StorageMetadata()
        meta.contentType = "image/jpeg"
        let path = "\(collection)/\(uuid)/\(UUID().uuidString)"
        let imageReference = storage.reference().child(path)
        
        let _ = try await imageReference.putDataAsync(data, metadata: meta)
        let url = try await imageReference.downloadURL()
        return (url: "\(url)", path: "\(path).jpeg")
    }
    
    func saveJpegImage(image: UIImage, collection: Collection, uuid: UUID) -> Future<ImageString, MinimoError> {
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
    
    func deleteImage(url: String) {
        Storage.storage().reference(forURL: url).delete { _ in }
    }
    
}

