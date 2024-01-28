//
//  TimelineViewModel.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/01/28.
//

import Foundation
import Combine

final class TimelineViewModel: ObservableObject {
    @Published var contents = [ContentsDTO]()
    @Published var error: Error?
    let user: UUID
    
    init(user: UUID) {
        self.user = user
    }
    
    func readTimeline() {
        do {
            let allData: [ContentsDTO] = try DecodingManager.shared.loadFile("test_contents.json")
            let filtered = allData.filter { $0.creator == self.user }
            contents = filtered
        } catch(let error) {
            self.error = error
        }
    }
}
