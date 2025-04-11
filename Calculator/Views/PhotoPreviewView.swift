////
////  PhotoPreviewView.swift
////  Calculator
////
////  Created by Mohan Periyasamy on 26/01/25.
////
//
//
//import SwiftUI
//
//struct PhotoPreviewView: View {
//    let photos: [SecurePhoto]
//    @State private var currentIndex: Int
//    @Environment(\.presentationMode) var presentationMode
//    @ObservedObject var viewModel: PhotoManagerViewModel
//    
//    init(photos: [SecurePhoto], initialIndex: Int, viewModel: PhotoManagerViewModel) {
//        self.photos = photos
//        self._currentIndex = State(initialValue: initialIndex)
//        self.viewModel = viewModel
//    }
//    
//    var body: some View {
//        NavigationView {
//            ZStack {
//                Color.black.edgesIgnoringSafeArea(.all)
//                
//                if !photos.isEmpty {
//                    Image(uiImage: photos[currentIndex].image)
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .edgesIgnoringSafeArea(.all)
//                        .gesture(
//                            DragGesture(minimumDistance: 50)
//                                .onEnded { value in
//                                    if value.translation.width < 0 {
//                                        // Swipe left
//                                        withAnimation {
//                                            currentIndex = min(currentIndex + 1, photos.count - 1)
//                                        }
//                                    } else if value.translation.width > 0 {
//                                        // Swipe right
//                                        withAnimation {
//                                            currentIndex = max(currentIndex - 1, 0)
//                                        }
//                                    }
//                                }
//                        )
//                }
//            }
//            .navigationBarTitleDisplayMode(.inline)
//            .toolbar {
//                ToolbarItem(placement: .navigationBarLeading) {
//                    Button("Close") {
//                        presentationMode.wrappedValue.dismiss()
//                    }
//                }
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    HStack {
//                        Button(action: {
//                            viewModel.movePhotoToPhotoLibrary(photos[currentIndex])
//                            presentationMode.wrappedValue.dismiss()
//                        }) {
//                            Image(systemName: "arrow.triangle.2.circlepath")
//                        }
//                        
//                        Button(action: {
//                            viewModel.deletePhoto(photos[currentIndex])
//                            if photos.count == 1 {
//                                presentationMode.wrappedValue.dismiss()
//                            } else {
//                                currentIndex = min(currentIndex, photos.count - 2)
//                            }
//                        }) {
//                            Image(systemName: "trash")
//                        }
//                    }
//                }
//            }
//        }
//    }
//}
//
