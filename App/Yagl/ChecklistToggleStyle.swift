//
//  ChecklistToggleStyle.swift
//  Yagl
//
//  Created by Kolmar Kafran on 29/11/22.
//

import SwiftUI

struct ChecklistToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button {
            configuration.isOn.toggle()
        } label: {
            HStack {
                Image(
                    systemName: configuration.isOn
                        ? "checkmark.circle.fill"
                        : "circle"
                )
                configuration.label
            }
        }
        .tint(.primary)
    }
}

extension ToggleStyle where Self == ChecklistToggleStyle {
    static var checklist: Self { Self() }
}
