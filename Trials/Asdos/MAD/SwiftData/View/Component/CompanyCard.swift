//
//  CompanyCard.swift
//  Trials
//
//  Created by Jason Miracle Gunawan on 28/04/26.
//

import SwiftUI

struct CompanyCard: View {
    let name: String
    let employeeCount: Int
    let address: String
    let activeProjectCount: Int
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(name)
                        .font(.headline)
                    Spacer()
                    HStack(spacing: 4) {
                        Text(employeeCount, format: .number)
                        Image(systemName: "person.fill")
                    }
                }
                Text(address)
                    .font(.caption)
                    .padding(.bottom, 8)
                Text("Active Project: \(activeProjectCount)")
                    .font(.subheadline)
            }
        }
        .padding(24)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(16)
    }
}

#Preview {
    CompanyCard(
        name: "PT. Sejahtera",
        employeeCount: 10,
        address: "Jalan Jati Baru 123, Kec. Baru",
        activeProjectCount: 15
    )
}
