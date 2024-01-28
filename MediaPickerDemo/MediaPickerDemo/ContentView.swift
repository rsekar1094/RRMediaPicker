//
//  ContentView.swift
//  MediaPickerDemo
//
//  Created by Raj S on 25/02/23.
//

import SwiftUI
import MediaPicker

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
