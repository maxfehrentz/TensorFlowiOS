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
    // delegate to communicate with the UI
    weak var cameraScreenDelegate: CameraScreenDelegate!
    //  handles all camera related functionality
    private let startSessionUseCase: StartSessionUseCase
    private let endSessionUseCase: EndSessionUseCase
    private(set) var runModelUseCase: RunModelUseCase
    
    init(cameraScreenDelegate: CameraScreenDelegate) {
        self.cameraScreenDelegate = cameraScreenDelegate
        let cameraCapture = CameraFeedManager(previewView: cameraScreenDelegate.getPreviewView())
        startSessionUseCase = StartSessionUseCase(cameraCapture: cameraCapture)
        endSessionUseCase = EndSessionUseCase(cameraCapture: cameraCapture)
        do {
            let modelDataHandler = try ModelDataHandler()
            runModelUseCase = RunModelUseCase(modelDataHandler: modelDataHandler)
        }
        catch let error {
            fatalError(error.localizedDescription)
        }
        cameraCapture.delegate = self
    }
    
    func startSession() {
        startSessionUseCase.invoke()
    }
    
    func stopSession() {
        endSessionUseCase.invoke()
    }
}
