//
//  StartSessionUseCase.swift
//  TensorFlowiOS
//
//  Created by Max on 05.10.20.
//

import Foundation

class StartSessionUseCase {
    
    private let cameraCapture: CameraFeedManager
    
    init(cameraCapture: CameraFeedManager) {
        self.cameraCapture = cameraCapture
    }
    
    func invoke() {
        cameraCapture.checkCameraConfigurationAndStartSession()
    }
}
