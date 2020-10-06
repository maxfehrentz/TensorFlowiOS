//
//  CameraScreenViewModel+CameraFeedManagerDelegate.swift
//  TensorFlowiOS
//
//  Created by Max on 05.10.20.
//

import Foundation
import AVFoundation
import os
import shared

extension CameraScreenViewModel: CameraFeedManagerDelegate {
    func cameraFeedManager(_ manager: CameraFeedManager, didOutput pixelBuffer: CVPixelBuffer) {
        DispatchQueue.main.async { [weak self] in
            if let overlayViewFrame = self?.cameraScreenDelegate.getOverlayViewFrame(), let previewViewFrame = self?.cameraScreenDelegate.getPreviewViewFrame(), let self = self {
                let (result, times): (Result, Times) =  self.runModelUseCase.invoke(pixelBuffer: pixelBuffer, overlayViewFrame: overlayViewFrame, previewViewFrame: previewViewFrame)
                // Draw result.
                // update inferencedData
                self.inferencedData = InferencedData(score: result.score, times: times)
                // If score is too low, clear result remaining in the overlayView.
                if result.score < Constants.Companion().minimumScore {
                    self.clearResult()
                    return
                }
                self.drawResult(of: result)
            }
        }
    }
    
    //  // MARK: Session Handling Alerts
    //  func cameraFeedManagerDidEncounterSessionRunTimeError(_ manager: CameraFeedManager) {
    //    // Handles session run time error by updating the UI and providing a button if session can be
    //    // manually resumed.
    //    self.resumeButton.isHidden = false
    //  }
    
    //  func cameraFeedManager(
    //    _ manager: CameraFeedManager, sessionWasInterrupted canResumeManually: Bool
    //  ) {
    //    // Updates the UI when session is interupted.
    //    if canResumeManually {
    //      self.resumeButton.isHidden = false
    //    } else {
    //      self.cameraUnavailableLabel.isHidden = false
    //    }
    //  }
    
    //  func cameraFeedManagerDidEndSessionInterruption(_ manager: CameraFeedManager) {
    //    // Updates UI once session interruption has ended.
    //    self.cameraUnavailableLabel.isHidden = true
    //    self.resumeButton.isHidden = true
    //  }
    
    func presentVideoConfigurationErrorAlert(_ manager: CameraFeedManager) {
        cameraScreenDelegate.showVideoConfigurationErrorAlert()
    }
    
    func presentCameraPermissionsDeniedAlert(_ manager: CameraFeedManager) {
        cameraScreenDelegate.showCameraPermissionDeniedAlert()
    }
    
    // To put `overlayView` area as model input, transform `overlayViewFrame` following transform
    // from `previewView` to `pixelBuffer`. `previewView` area is transformed to fit in
    // `pixelBuffer`, because `pixelBuffer` as a camera output is resized to fill `previewView`.
    
    func drawResult(of result: Result) {
        cameraScreenDelegate.drawResult(of: result)
    }
    
    func clearResult() {
        cameraScreenDelegate.clearResult()
    }
}

