//
//  BlurView.swift
//  Locations App
//
//  Created by Kevin Li on 2/3/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//

import SwiftUI

import SwiftUI

struct BlurView: UIViewRepresentable {

   let style: UIBlurEffect.Style

   func makeUIView(context: UIViewRepresentableContext<BlurView>) -> UIView {
      let view = UIView(frame: .zero)
      view.backgroundColor = .clear
      let blurEffect = UIBlurEffect(style: style)
      let blurView = UIVisualEffectView(effect: blurEffect)
      blurView.translatesAutoresizingMaskIntoConstraints = false
      view.insertSubview(blurView, at: 0)
      NSLayoutConstraint.activate([
         blurView.heightAnchor.constraint(equalTo: view.heightAnchor),
         blurView.widthAnchor.constraint(equalTo: view.widthAnchor),
      ])
      return view
   }

   func updateUIView(_ uiView: UIView,
                     context: UIViewRepresentableContext<BlurView>) {}
}


struct BlurView_Previews: PreviewProvider {
    static var previews: some View {
        BlurView(style: .systemMaterialDark)
    }
}
