//
//  LanguageCard.swift
//  storyblok-ultimate-tutorial-ios
//
//  Created by Amit Sen on 17.01.25.
//

import SwiftUI

struct LanguageCard: ViewComponent {
    let language: Language
    let isSelected: Bool

    var bodyContent: some View {
        HStack(spacing: 16) {
            Text(language.flag)
                .font(.largeTitle)

            VStack(alignment: .leading, spacing: 4) {
                Text(language.name)
                    .font(.headline)
                Text(language.code ?? "en")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            Spacer()

            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.blue)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}
