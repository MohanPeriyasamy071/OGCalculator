//
//  PhotoManagerViewModel.swift
//  Calculator
//
//  Created by Mohan Periyasamy on 26/01/25.
//
import SwiftUI
import PhotosUI
import Photos

class PhotoManagerViewModel: ObservableObject {
    @Published var selectedItems: [PhotosPickerItem] = []
    @Published var selectedPhotos: [SecurePhoto] = []
    @Published var savedPhotos: [SecurePhoto] = []
    @Published var showError = false
    @Published var errorMessage = ""
    @Published var isShowingPreview = false
    
    var allPhotos: [SecurePhoto] {
        savedPhotos + selectedPhotos
    }
    
    func checkPhotoLibraryPermission() {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
            switch status {
            case .authorized, .limited:
                print("Photo library access granted")
            case .denied, .restricted:
                DispatchQueue.main.async {
                    self.showError = true
                    self.errorMessage = "Photo library access denied. Please enable it in Settings."
                }
            case .notDetermined:
                print("Photo library access not determined")
            @unknown default:
                break
            }
        }
    }
    
    @MainActor
    func loadSelectedPhotos() async {
        selectedPhotos.removeAll()
        
        for item in selectedItems {
            if let data = try? await item.loadTransferable(type: Data.self),
               let uiImage = UIImage(data: data) {
                let securePhoto = SecurePhoto(id: UUID(), image: uiImage, assetIdentifier: item.itemIdentifier)
                selectedPhotos.append(securePhoto)
            }
        }
        
        isShowingPreview = !selectedPhotos.isEmpty
    }
    
    @MainActor
    func secureAndDeletePhotos() async {
        do {
            try await savePhotosToDocuments()
            try await deletePhotosFromLibrary()
            loadSavedPhotos()
            selectedItems.removeAll()
            selectedPhotos.removeAll()
            isShowingPreview = false
        } catch {
            showError = true
            errorMessage = error.localizedDescription
        }
    }
    
    private func savePhotosToDocuments() async throws {
        for photo in selectedPhotos {
            let fileName = "securePhoto_\(photo.id).jpg"
            let fileURL = getDocumentsDirectory().appendingPathComponent(fileName)
            
            if let data = photo.image.jpegData(compressionQuality: 0.8) {
                try data.write(to: fileURL)
                print("Saved photo to: \(fileURL.path)")
            }
        }
    }
    
    private func deletePhotosFromLibrary() async throws {
        let identifiers = selectedPhotos.compactMap { $0.assetIdentifier }
        guard !identifiers.isEmpty else { return }
        
        let assets = PHAsset.fetchAssets(withLocalIdentifiers: identifiers, options: nil)
        try await PHPhotoLibrary.shared().performChanges {
            PHAssetChangeRequest.deleteAssets(assets)
        }
        print("Deleted \(assets.count) photos from library")
    }
    
    func loadSavedPhotos() {
        let fileManager = FileManager.default
        let documentsURL = getDocumentsDirectory()
        
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            savedPhotos = fileURLs.compactMap { url -> SecurePhoto? in
                guard url.pathExtension == "jpg" else { return nil }
                if let image = UIImage(contentsOfFile: url.path) {
                    return SecurePhoto(id: UUID(), image: image, assetIdentifier: nil)
                }
                return nil
            }
        } catch {
            print("Error loading saved photos: \(error)")
        }
    }
    
    private func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    func deletePhoto(_ photo: SecurePhoto) {
        if let index = savedPhotos.firstIndex(where: { $0.id == photo.id }) {
            savedPhotos.remove(at: index)
            deletePhotoFile(for: photo)
        } else if let index = selectedPhotos.firstIndex(where: { $0.id == photo.id }) {
            selectedPhotos.remove(at: index)
        }
    }

    private func deletePhotoFile(for photo: SecurePhoto) {
        let fileName = "securePhoto_\(photo.id).jpg"
        let fileURL = getDocumentsDirectory().appendingPathComponent(fileName)
        
        do {
            try FileManager.default.removeItem(at: fileURL)
            print("Deleted photo file: \(fileURL.path)")
        } catch {
            print("Error deleting photo file: \(error.localizedDescription)")
        }
    }

      func movePhotoToPhotoLibrary(_ photo: SecurePhoto) {
          PHPhotoLibrary.shared().performChanges {
              PHAssetChangeRequest.creationRequestForAsset(from: photo.image)
          } completionHandler: { success, error in
              if success {
                  DispatchQueue.main.async {
                      self.deletePhoto(photo)
                  }
              } else if let error = error {
                  print("Error moving photo to library: \(error.localizedDescription)")
              }
          }
      }
}

