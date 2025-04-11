//
//  MCHiddenAlbumView.swift
//  Calculator
//
//  Created by Mohan Periyasamy on 26/01/25.
//

import SwiftUI
import PhotosUI
import Photos

struct MCHiddenAlbumView: View {
    @Binding var shouldShowHiddenAlbum : Bool
    @StateObject private var viewModel = PhotoManagerViewModel()
    @State private var showingPhotosPicker = false
    @State private var showingFullPreview = false
    @State private var previewIndex = 0
    

    var body: some View {
        NavigationView {
            ZStack {
                photoGrid
                
                if viewModel.isShowingPreview {
                    bottomPreviewSheet
                }
            }
            .navigationTitle("Secure Photos")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        shouldShowHiddenAlbum = false
                    }) {
                        Text("Close")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingPhotosPicker = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .photosPicker(isPresented: $showingPhotosPicker, selection: $viewModel.selectedItems, matching: .images,photoLibrary : .shared())
            .onChange(of: viewModel.selectedItems) { _ in
                Task {
                    await viewModel.loadSelectedPhotos()
                }
            }
            .sheet(isPresented: $showingFullPreview) {
                PhotoPreviewView(photos: viewModel.allPhotos, initialIndex: previewIndex, viewModel: viewModel)
            }
        }
        .onAppear {
            viewModel.checkPhotoLibraryPermission()
            viewModel.loadSavedPhotos()
        }
    }
    private var photosPicker: some View {
           PhotosPicker(
               selection: $viewModel.selectedItems,
               matching: .images,
               photoLibrary: .shared()
           ) {
               Text("Select Photos")
                   .frame(maxWidth: .infinity)
                   .padding()
                   .background(Color.blue)
                   .foregroundColor(.white)
                   .cornerRadius(10)
           }
           .onChange(of: viewModel.selectedItems) { _ in
               Task {
                   await viewModel.loadSelectedPhotos()
               }
           }
       }
    
    private var photoGrid: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 2) {
                ForEach(viewModel.allPhotos.indices, id: \.self) { index in
                    let photo = viewModel.allPhotos[index]
                    Image(uiImage: photo.image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .clipped()
                        .onTapGesture {
                            previewIndex = index
                            showingFullPreview = true
                        }
                }
            }
            .padding(2)
        }
    }
    
    private var bottomPreviewSheet: some View {
        VStack {
            Spacer()
            VStack {
                HStack {
                    Text("Selected Photos")
                        .font(.headline)
                    Spacer()
                    Button("Done") {
                        Task {
                            await viewModel.secureAndDeletePhotos()
                        }
                    }
                }
                .padding()
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(viewModel.selectedPhotos) { photo in
                            Image(uiImage: photo.image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 80, height: 80)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }
                    .padding(.horizontal)
                }
                .frame(height: 100)
            }
            .background(Color(.systemBackground))
            .cornerRadius(15)
            .shadow(radius: 5)
        }
        .transition(.move(edge: .bottom))
        .animation(.spring(), value: viewModel.isShowingPreview)
    }
    
 
}

struct PhotoPreviewView: View {
    let photos: [SecurePhoto]
    @State private var currentIndex: Int
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: PhotoManagerViewModel
    
    init(photos: [SecurePhoto], initialIndex: Int, viewModel: PhotoManagerViewModel) {
        self.photos = photos
        self._currentIndex = State(initialValue: initialIndex)
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                if !photos.isEmpty {
                    Image(uiImage: photos[currentIndex].image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .edgesIgnoringSafeArea(.all)
                        .gesture(
                            DragGesture(minimumDistance: 50)
                                .onEnded { value in
                                    if value.translation.width < 0 {
                                        // Swipe left
                                        withAnimation {
                                            currentIndex = min(currentIndex + 1, photos.count - 1)
                                        }
                                    } else if value.translation.width > 0 {
                                        // Swipe right
                                        withAnimation {
                                            currentIndex = max(currentIndex - 1, 0)
                                        }
                                    }
                                }
                        )
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                       
                        Button(action: {
                            viewModel.movePhotoToPhotoLibrary(photos[currentIndex])
                            if photos.count == 1 {
                                presentationMode.wrappedValue.dismiss()
                            } else {
                                currentIndex = min(currentIndex, photos.count - 2)
                            }
                        }) {
                            Image(systemName: "arrow.triangle.2.circlepath")
                        }
                        
                        Button(action: {
                            viewModel.deletePhoto(photos[currentIndex])
                            if photos.count == 1 {
                                presentationMode.wrappedValue.dismiss()
                            } else {
                                currentIndex = min(currentIndex, photos.count - 2)
                            }
                        }) {
                            Image(systemName: "trash")
                        }
                    }
                }
                }
            }
        }
    }

