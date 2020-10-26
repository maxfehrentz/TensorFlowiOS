//
//  CameraScreenViewModel.swift
//  TensorFlowiOS
//
//  Created by Max on 05.10.20.
//

import Foundation
import shared
import UIKit
import Flutter
import RxCocoa
import RxSwift

class CameraScreenViewModel: NSObject {
        
    var inferencedData: InferencedData?
    // delegate to communicate with the UI
    weak var cameraScreenDelegate: CameraScreenDelegate!
    //  handles all camera related functionality
    private let startSessionUseCase: StartSessionUseCase
    private let endSessionUseCase: EndSessionUseCase
    private(set) var runModelUseCase: RunModelUseCase
    let overlayViewFrame: CGRect
    let previewViewFrame: CGRect
    let testChannel: FlutterMethodChannel!
    let eventChannel: FlutterEventChannel!
    let behaviorRelay = BehaviorRelay<Float>(value: 0)
    let disposeBag = DisposeBag()
    
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
        let flutterEngine = (UIApplication.shared.delegate as! AppDelegate).flutterEngine
        let flutterViewController =
            FlutterViewController(engine: flutterEngine, nibName: nil, bundle: nil)
        testChannel = FlutterMethodChannel(name: "testChannel", binaryMessenger: flutterViewController.binaryMessenger)
        eventChannel = FlutterEventChannel(name: "eventChannel", binaryMessenger: flutterViewController.binaryMessenger)
        super.init()
        testChannel.setMethodCallHandler { [weak self] call, result in
            if call.method == "startObservingCamera" {
                self?.startSession()
            }
        }
        eventChannel.setStreamHandler(self)
        cameraHandler.delegate = self
        cameraScreenDelegate.presentFlutterViewController(flutterViewController)
    }
    
    func startSession() {
        startSessionUseCase.invoke()
    }
    
    func stopSession() {
        endSessionUseCase.invoke()
    }
}

