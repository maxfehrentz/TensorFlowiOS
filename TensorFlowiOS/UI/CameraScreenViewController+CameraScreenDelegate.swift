//
//  CameraScreenViewController+CameraScreenDelegate.swift
//  TensorFlowiOS
//
//  Created by Max on 05.10.20.
//

import Foundation
import UIKit

extension CameraScreenViewController: CameraScreenDelegate {
    
    func showVideoConfigurationErrorAlert() {
        let alertController = UIAlertController(
          title: "Confirguration Failed", message: "Configuration of camera has failed.",
          preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(okAction)

        present(alertController, animated: true, completion: nil)
    }
    
    func showCameraPermissionDeniedAlert() {
        let alertController = UIAlertController(
          title: "Camera Permissions Denied",
          message:
            "Camera permissions have been denied for this app. You can change this by going to Settings",
          preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { action in
          if let url = URL.init(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
          }
        }

        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)

        present(alertController, animated: true, completion: nil)
    }
    
    func drawResult(of result: Result) {
        DispatchQueue.main.async { [weak self] in
            self?.overlayView.dots = result.dots
            self?.overlayView.lines = result.lines
            self?.overlayView.setNeedsDisplay()
        }
    }
    
    func clearResult() {
        DispatchQueue.main.async { [weak self] in
            self?.overlayView.clear()
            self?.overlayView.setNeedsDisplay()
        }
    }
    
    func getOverlayViewFrame() -> CGRect {
        return view.frame
    }

    func getPreviewViewFrame() -> CGRect {
        return view.frame
    }
    
    func getPreviewView() -> PreviewView {
        return previewView
    }
}
