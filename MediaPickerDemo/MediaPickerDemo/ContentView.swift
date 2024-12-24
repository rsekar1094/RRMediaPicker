//
//  ContentView.swift
//  MediaPickerDemo
//
//  Created by Raj S on 25/02/23.
//

import SwiftUI
import MediaPicker
import RRMediaView

struct ContentView: View {
    
    @State var selectedMediaTypes: [MediaType] = []
    @State var isMediaPickerSelected: Bool = false
    @State var isMediaPickerProcessing: Bool = false
    @State var selectedSourceType: MediaPickerSourceType = .gallery
    
    
    var body: some View {
        ScrollView(.vertical) {
            ZStack(alignment: .topTrailing) {
                
                LazyVGrid(
                    columns: [
                        GridItem(
                            .adaptive(minimum: 200, maximum: 200)
                        ),
                        GridItem(
                            .adaptive(minimum: 200, maximum: 200)
                        )
                    ],
                    alignment: .leading,
                    spacing: 0,
                    content: {
                        ForEach(
                            Array(selectedMediaTypes.enumerated()), id: \.offset
                        ) { offset, type  in
                            MediaView(
                                mediaType: type,
                                size: .height(300)
                            )
                        }
                    }
                )
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .padding(.top, 80)
                
                Picker(
                    "Pick your source type",
                    selection: $selectedSourceType,
                    content: {
                        Text("Camera")
                            .tag(MediaPickerSourceType.camera)
                        
                        Text("Gallery")
                            .tag(MediaPickerSourceType.gallery)
                        
                        Text("Document")
                            .tag(MediaPickerSourceType.document)
                    }
                )
                .pickerStyle(.segmented)
                .background(Color.white)
                
                Button(
                    action: {
                        isMediaPickerSelected = true
                    }, label: {
                        Text("Pick media")
                    }
                )
                .padding()
                .padding(.top, 40)
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(Color.black)
        .fullScreenCover(
            isPresented: $isMediaPickerSelected,
            content: {
                MediaPickerView(
                    isPresenting: $isMediaPickerSelected, isProcessing: $isMediaPickerProcessing, viewModel: .init(
                        sourceType: selectedSourceType,
                        inputType: .bothImageAndVideo,
                        selectionLimit: 0
                    ),
                    selection: { data in
                        
                        var types: [MediaType] = []
                        types.append(contentsOf: data.videos.map { .video(.local($0)) })
                        types.append(contentsOf: data.images.map { .image(.local($0)) })
                        
                        self.selectedMediaTypes = types
                        
                    }
                )
            }
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension URL: @retroactive MediaSourceURL {
    public var url: URL {
        return self
    }
    
    public var cacheKey: String {
        return self.absoluteString
    }
}
