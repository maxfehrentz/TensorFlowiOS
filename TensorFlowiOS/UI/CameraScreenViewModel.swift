//
//  CameraScreenViewModel.swift
//  TensorFlowiOS
//
//  Created by Max on 05.10.20.
//

import Foundation
import shared

class CameraScreenViewModel {
    
    var inferencedData: InferencedData?
    // handles all data preprocessing and makes calls to run inference
    private(set) var modelDataHandler: ModelDataHandler!
    weak var cameraScreenDelegate: CameraScreenDelegate!
    //  handles all camera related functionality
    private var cameraCapture: CameraFeedManager!
    
    init(cameraScreenDelegate: CameraScreenDelegate) {
        self.cameraScreenDelegate = cameraScreenDelegate
        do {
          modelDataHandler = try ModelDataHandler()
        }
        catch let error {
          fatalError(error.localizedDescription)
        }
        cameraCapture = CameraFeedManager(previewView: cameraScreenDelegate.getPreviewView())
        cameraCapture.delegate = self
    }
    
    func startSession() {
        cameraCapture.checkCameraConfigurationAndStartSession()
    }
    
    func stopSession() {
        cameraCapture.stopSession()
    }
}
