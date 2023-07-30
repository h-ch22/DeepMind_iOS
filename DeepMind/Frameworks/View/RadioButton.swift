//
//  RadioButton.swift
//  DysarthriaChecker
//
//  Created by Changjin Ha on 2023/05/02.
//

import SwiftUI

struct RadioButton<Tag, CircleButton, Label>: View
where Tag : Hashable, CircleButton : View, Label : View {
  let tag: Tag
  @Binding var selection: Tag?
  @ViewBuilder let button: (Bool) -> CircleButton
  @ViewBuilder let label: () -> Label

  var body: some View {
    Button {
      selection = tag
    } label: {
      HStack {
        button(selection == tag)
        label()
      }
    }
    .buttonStyle(.plain)
  }
}
