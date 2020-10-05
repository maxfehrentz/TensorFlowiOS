//
//  ViewController.swift
//  TensorFlowiOS
//
//  Created by Max on 29.09.20.
//

import UIKit
import shared
import SnapKit
import os

class ViewController: UIViewController {
    
    private var previewView = PreviewView()
    private var overlayView = OverlayView()
    // MARK: ModelDataHandler traits
    private let threadCount = 2
    private let delegate = "NPU"
    
    // MARK: result variable
    private var inferencedData: InferencedData?
    
    private let minimumScore: Float = 0.2
    private var overlayViewFrame: CGRect?
    private var previewViewFrame: CGRect?
    // MARK: Manager that handles all camera related functionality
    private lazy var cameraCapture = CameraFeedManager(previewView: previewView)
    
    // MARK: Handler that handles all data preprocessing and makes calls to run inference
    private var modelDataHandler: ModelDataHandler!

    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        layoutSubviews()
        configureSubviews()
        // Do any additional setup after loading the view.
        do {
          modelDataHandler = try ModelDataHandler()
        }
        catch let error {
          fatalError(error.localizedDescription)
        }
        cameraCapture.delegate = self
    }
    
    private func addSubviews() {
        view.addSubview(previewView)
        view.addSubview(overlayView)
    }
    
    private func layoutSubviews() {
        previewView.snp.makeConstraints { (make) in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        // TODO: overlayView will probably need different constraints
        overlayView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(40)
        }
    }
    
    private func configureSubviews() {
        overlayView.backgroundColor = UIColor.clear
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraCapture.checkCameraConfigurationAndStartSession()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
      cameraCapture.stopSession()
    }

    override func viewDidLayoutSubviews() {
      overlayViewFrame = overlayView.frame
      previewViewFrame = previewView.frame
    }

}

// MARK: - CameraFeedManagerDelegate Methods
extension ViewController: CameraFeedManagerDelegate {
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
    let alertController = UIAlertController(
      title: "Confirguration Failed", message: "Configuration of camera has failed.",
      preferredStyle: .alert)
    let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
    alertController.addAction(okAction)

    present(alertController, animated: true, completion: nil)
  }

  func presentCameraPermissionsDeniedAlert(_ manager: CameraFeedManager) {
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

  @objc func runModel(on pixelBuffer: CVPixelBuffer) {
    guard let overlayViewFrame = overlayViewFrame, let previewViewFrame = previewViewFrame
    else {
      return
    }
    // To put `overlayView` area as model input, transform `overlayViewFrame` following transform
    // from `previewView` to `pixelBuffer`. `previewView` area is transformed to fit in
    // `pixelBuffer`, because `pixelBuffer` as a camera output is resized to fill `previewView`.
    // https://developer.apple.com/documentation/avfoundation/avlayervideogravity/1385607-resizeaspectfill
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
      if result.score < self.minimumScore {
        self.clearResult()
        return
      }
      self.drawResult(of: result)
    }
  }

  func drawResult(of result: Result) {
    self.overlayView.dots = result.dots
    self.overlayView.lines = result.lines
    self.overlayView.setNeedsDisplay()
  }

  func clearResult() {
    self.overlayView.clear()
    self.overlayView.setNeedsDisplay()
  }
}

