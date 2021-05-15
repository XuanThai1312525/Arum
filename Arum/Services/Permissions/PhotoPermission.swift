//
//  PhotoPermission.swift
//  LANE4
//
//  Created by Thai Nguyen on 26/11/2020.
//  Copyright © 2020 LinhNM7. All rights reserved.
//

import UIKit
import Photos

class PhotoPermission: NSObject {
    
    // MARK: - Closures
    private var didPickImage: ((_ image: UIImage?) -> Void)?
    
    // MARK: - Static variables
    static var photoAuthStatus: PHAuthorizationStatus {
        return PHPhotoLibrary.authorizationStatus()
    }
    
    static var isNotDetermined: Bool {
        return PhotoPermission.photoAuthStatus == .notDetermined
    }
    
    static var isAuthorized: Bool {
        return PhotoPermission.photoAuthStatus == .authorized
    }
    
    static var isDenied: Bool {
        return PhotoPermission.photoAuthStatus == .denied
    }
    
    // MARK: - Static functions
    static func requestPhotoPermission(completion: @escaping ((_ authorized: Bool) -> Void)) {
        switch photoAuthStatus {
        case .authorized:
            completion(true)
        case .denied:
            completion(false)
        default:
            PHPhotoLibrary.requestAuthorization { status in
                DispatchQueue.main.async {
                    completion(status == .authorized)
                }
            }
        }
    }
    
    // MARK: - Local functions
    func showPhotoLibraryScreen(canEdit: Bool = false, didDenyPermission: (() -> Void)? = nil, didPickImage: @escaping ((_ image: UIImage?) -> Void)) {
        func moveToImagePickerScreen() {
            guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
                didPickImage(nil)
                return
            }
            self.didPickImage = didPickImage
            let cameraView = UIImagePickerController()
            cameraView.delegate = self
            cameraView.sourceType = .photoLibrary
            cameraView.allowsEditing = canEdit
            UIViewController.top()?.present(cameraView, animated: true, completion: nil)
        }
        switch PhotoPermission.photoAuthStatus {
        case .notDetermined:
            PhotoPermission.requestPhotoPermission(completion: { granted in
                if granted {
                    moveToImagePickerScreen()
                } else {
                    didDenyPermission?()
                }
            })
        case .authorized:
            moveToImagePickerScreen()
        case .denied:
            didDenyPermission?()
        default: break
        }
    }
}

extension PhotoPermission: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: {
            guard let image = info[.originalImage] as? UIImage else {
                self.didPickImage?(nil)
                return
            }
            self.didPickImage?(image)
        })
    }
}
