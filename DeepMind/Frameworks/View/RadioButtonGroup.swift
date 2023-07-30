//
//  RadioButton.swift
//  DysarthriaChecker
//
//  Created by Changjin Ha on 2023/05/02.
//

import SwiftUI

struct RadioButtonGroup<Tag, CircleButton, Label>: View
where Tag : Hashable, CircleButton : View, Label : View {
  @Binding var selection: Tag?
  let orientation: Orientation
  let tags: [Tag]
  @ViewBuilder let button: (Bool) -> CircleButton
  @ViewBuilder let label: (Tag) -> Label

  var body: some View {
    ((orientation == .horizonal)
     ? AnyLayout(HStackLayout(alignment: .top))
     : AnyLayout(VStackLayout(alignment: .leading))) {
      ForEach(tags, id: \.self) { tag in
        RadioButton(tag: tag, selection: $selection, button: button) {
          label(tag)
        }
      }
    }
  }

  enum Orientation {
    case horizonal, vertical
  }
}
