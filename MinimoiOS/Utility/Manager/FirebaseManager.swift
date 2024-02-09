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
    
    func readSingleDataAsync<T: Decodable>(from collection: Collection, query: Filter) async throws -> T {
        let snapshot = try await Firestore.firestore().collection(collection.name).whereFilter(query).getDocuments()
        let dataArray = try snapshot.documents.reduce(into: []) { $0.append(try $1.data(as: T.self)) }
        guard let data = dataArray.first else {
            throw MinimoError.dataNotFound
        }
        return data
    }
    
    func readMultipleDataAsync<T: Decodable>(from collection: Collection, query: Filter) async throws -> [T] {
        let ref = Firestore.firestore().collection(collection.name).whereFilter(query)
        let snapshot = try await ref.getDocuments()
        let dataArray = try snapshot.documents.reduce(into: []) { $0.append(try $1.data(as: T.self)) }
        return dataArray
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
    
    func updateData(from collection: Collection, uuid: UUID, data: [AnyHashable: Any]) async throws {
        try await Firestore.firestore().collection(collection.name).document(uuid.uuidString).updateData(data)
    }
    
    func deleteData(from collection: Collection, uuid: UUID) async throws {
        try await Firestore.firestore().collection(collection.name).document(uuid.uuidString)
            .updateData(collection.fields.reduce(into: [:]) { $0[$1] = FieldValue.delete() })
        try await Firestore.firestore().collection(collection.name).document(uuid.uuidString).delete()
    }
    
    func deleteImage(url: String) {
        Storage.storage().reference(forURL: url).delete { _ in }
    }
}

