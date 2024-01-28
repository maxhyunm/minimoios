//
//  TimelineRow.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/01/28.
//

import SwiftUI

struct TimelineRow: View {
    let name: String
    let date: String
    let content: String
    
    var body: some View {
        HStack {
            VStack {
                Image(systemName: "teddybear.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .background(.white)
                    .foregroundColor(.pink)
                    .cornerRadius(45)
                    .frame(maxWidth: 50)
                Spacer()
            }
            VStack(alignment: .leading, spacing: 10) {
                Text(name)
                    .font(.headline)
                Text(content)
                    .lineLimit(nil)
                    .font(.body)
                Text(date)
                    .font(.caption2)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.trailing)
        }
        .padding()
        .background(Color(white: 0.9))
        .cornerRadius(10)
    }
}

struct TimelineRow_Previews: PreviewProvider {
    static var previews: some View {
        TimelineRow(name: "a", date: "b", content: "cdefg")
    }
}
