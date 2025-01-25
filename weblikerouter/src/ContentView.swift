//
//  ContentView.swift
//  weblikerouter
//
//  Created by oein on 1/26/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        WRouterView { url, qparm in
            switch url {
            default:
                WRouter_NotFound()
            }
        }
    }
}

#Preview {
    ContentView()
}
