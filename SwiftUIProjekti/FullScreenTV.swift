//
//  FullScreenTV.swift
//  SwiftUIProjekti
//
//  Created by Joona Martinkauppi on 2.3.2021.
//

import Foundation
import SwiftUI
import RemoteContentView

struct FullScreenTV: View {
    var body: some View {
        VStack{
            Color.red
            Image(uiImage: testiUrl2.load()).resizable().scaledToFit()        }
    }
}
struct FullScreenTV_Previews: PreviewProvider {
    static var previews: some View {
        FullScreenTV()
    }
}
