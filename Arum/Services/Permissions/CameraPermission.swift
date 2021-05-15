//
//  CameraPermission.swift
//  LANE4
//
//  Created by Thai Nguyen on 26/11/2020.
//  Copyright © 2020 LinhNM7. All rights reserved.
//

import UIKit
import AVFoundation

class CameraPermission: NSObject {
    
    // MARK: - Closures
    private var didPickImage: ((_ image: UIImage?) -> Void)?
    
    // MARK: - Static variables
    static var cameraAuthStatus: AVAuthorizationStatus {
        return AVCaptureDevice.authorizationStatus(for: .video)
    }
    
    static var isNotDetermined: Bool {
        return CameraPermission.cameraAuthStatus == .notDetermined
    }
    
    static var isAuthorized: Bool {
        return CameraPermission.cameraAuthStatus == .authorized
    }
    
    static var isDenied: Bool {
        return CameraPermission.cameraAuthStatus == .denied
    }
    
    // MARK: - Static functions
    static func requestCameraPermission(completion: @escaping ((_ authorized: Bool) -> Void)) {
        switch cameraAuthStatus {
        case .authorized:
            completion(true)
        case .denied:
            completion(false)
        default:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    completion(granted)
                }
            }
        }
    }
    
    // MARK: - Local functions
    func showCameraScreen(didDenyPermission: (() -> Void)? = nil, didPickImage: @escaping ((_ image: UIImage?) -> Void)) {
        func moveToImagePickerScreen() {
            guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
                didPickImage(nil)
                return
            }
            self.didPickImage = didPickImage
            let cameraView = UIImagePickerController()
            cameraView.delegate = self
            cameraView.sourceType = .camera
            UIViewController.top()?.present(cameraView, animated: true, completion: nil)
        }
        switch CameraPermission.cameraAuthStatus {
        case .notDetermined:
            CameraPermission.requestCameraPermission(completion: { granted in
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

extension CameraPermission: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
