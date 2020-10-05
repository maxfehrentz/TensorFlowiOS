//
//  CameraFeedManagerDelegate.swift
//  TensorFlowiOS
//
//  Created by Max on 05.10.20.
//

import Foundation
import AVFoundation

@objc protocol CameraFeedManagerDelegate: class {
  /// This method delivers the pixel buffer of the current frame seen by the device's camera.
  @objc optional func cameraFeedManager(
    _ manager: CameraFeedManager, didOutput pixelBuffer: CVPixelBuffer
  )

//  /// This method initimates that a session runtime error occured.
//  func cameraFeedManagerDidEncounterSessionRunTimeError(_ manager: CameraFeedManager)
//
//  /// This method initimates that the session was interrupted.
//  func cameraFeedManager(
//    _ manager: CameraFeedManager, sessionWasInterrupted canResumeManually: Bool
//  )
//
//  /// This method initimates that the session interruption has ended.
//  func cameraFeedManagerDidEndSessionInterruption(_ manager: CameraFeedManager)

  /// This method initimates that there was an error in video configurtion.
  func presentVideoConfigurationErrorAlert(_ manager: CameraFeedManager)

  /// This method initimates that the camera permissions have been denied.
  func presentCameraPermissionsDeniedAlert(_ manager: CameraFeedManager)
}
