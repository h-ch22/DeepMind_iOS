//
//  FittingFontSizeModifier.swift
//  DeepMind
//
//  Created by Ha Changjin on 10/4/23.
//

import SwiftUI

struct FittingFontSizeModifier: ViewModifier {
  func body(content: Content) -> some View {
    content
      .font(.system(size: 100))
      .minimumScaleFactor(0.001)
  }
}
