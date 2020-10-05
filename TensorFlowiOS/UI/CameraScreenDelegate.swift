//
//  CameraScreenDelegate.swift
//  TensorFlowiOS
//
//  Created by Max on 05.10.20.
//

import Foundation
import UIKit

protocol CameraScreenDelegate: AnyObject {
    func showVideoConfigurationErrorAlert()
    func showCameraPermissionDeniedAlert()
    func drawResult(of result: Result)
    func clearResult()
    func getOverlayViewFrame() -> CGRect?
    func getPreviewViewFrame() -> CGRect?
    func getPreviewView() -> PreviewView
}
