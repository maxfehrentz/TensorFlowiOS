//
//  CameraScreenViewModel.swift
//  TensorFlowiOS
//
//  Created by Max on 05.10.20.
//

import Foundation
import shared
import UIKit

class CameraScreenViewModel {
    
    var inferencedData: InferencedData?
    // delegate to communicate with the UI
    weak var cameraScreenDelegate: CameraScreenDelegate!
    //  handles all camera related functionality
    private let startSessionUseCase: StartSessionUseCase
    private let endSessionUseCase: EndSessionUseCase
    private(set) var runModelUseCase: RunModelUseCase
    let overlayViewFrame: CGRect
    let previewViewFrame: CGRect
    
    init(cameraScreenDelegate: CameraScreenDelegate) {
        self.cameraScreenDelegate = cameraScreenDelegate
        self.overlayViewFrame = cameraScreenDelegate.getOverlayViewFrame()
        self.previewViewFrame = cameraScreenDelegate.getPreviewViewFrame()
        let cameraHandler = CameraFeedManager(previewView: cameraScreenDelegate.getPreviewView())
        startSessionUseCase = StartSessionUseCase(cameraHandler: cameraHandler)
        endSessionUseCase = EndSessionUseCase(cameraHandler: cameraHandler)
        do {
            let modelDataHandler = try ModelDataHandler()
            runModelUseCase = RunModelUseCase(modelDataHandler: modelDataHandler)
        }
        catch let error {
            fatalError(error.localizedDescription)
        }
        cameraHandler.delegate = self
    }
    
    func startSession() {
        startSessionUseCase.invoke()
    }
    
    func stopSession() {
        endSessionUseCase.invoke()
    }
}
