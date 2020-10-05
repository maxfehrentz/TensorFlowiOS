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
    runModel(on: pixelBuffer)
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

  @objc func runModel(on pixelBuffer: CVPixelBuffer) {
    DispatchQueue.main.sync {
        guard let overlayViewFrame = cameraScreenDelegate.getOverlayViewFrame(), let previewViewFrame = cameraScreenDelegate.getPreviewViewFrame()
        else {
          return
        }
        DispatchQueue.global(qos: .userInitiated).sync {
            //https://developer.apple.com/documentation/avfoundation/avlayervideogravity/1385607-resizeaspectfill
            let modelInputRange = overlayViewFrame.applying(
              previewViewFrame.size.transformKeepAspect(toFitIn: pixelBuffer.size))

            // Run PoseNet model.
            guard
              let (result, times) = self.modelDataHandler?.runPoseNet(
                on: pixelBuffer,
                from: modelInputRange,
                to: overlayViewFrame.size)
            else {
              os_log("Cannot get inference result.", type: .error)
              return
            }

            // Udpate `inferencedData` to render data in `tableView`.
            inferencedData = InferencedData(score: result.score, times: times)

            // Draw result.
            DispatchQueue.main.async {
              // If score is too low, clear result remaining in the overlayView.
                if result.score < Constants.Companion().minimumScore {
                self.clearResult()
                return
              }
              self.drawResult(of: result)
            }
        }
    }
    // To put `overlayView` area as model input, transform `overlayViewFrame` following transform
    // from `previewView` to `pixelBuffer`. `previewView` area is transformed to fit in
    // `pixelBuffer`, because `pixelBuffer` as a camera output is resized to fill `previewView`.
  }

  func drawResult(of result: Result) {
    cameraScreenDelegate.drawResult(of: result)
  }

  func clearResult() {
    cameraScreenDelegate.clearResult()
  }
}

