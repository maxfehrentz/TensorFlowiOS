//
//  RunModelUseCase.swift
//  TensorFlowiOS
//
//  Created by Max on 05.10.20.
//

import Foundation
import AVFoundation
import os
import shared

class RunModelUseCase {
    
    private let modelDataHandler: ModelDataHandler
    
    init(modelDataHandler: ModelDataHandler) {
        self.modelDataHandler = modelDataHandler
    }
    
    func invoke(pixelBuffer: CVBuffer, overlayViewFrame: CGRect, previewViewFrame: CGRect) -> (Result, Times) {
        DispatchQueue.global(qos: .userInitiated).sync { [weak self] in
            //https://developer.apple.com/documentation/avfoundation/avlayervideogravity/1385607-resizeaspectfill
            let modelInputRange = overlayViewFrame.applying(
                previewViewFrame.size.transformKeepAspect(toFitIn: pixelBuffer.size))
            // Run PoseNet model.
            return self?.modelDataHandler.runPoseNet(
                on: pixelBuffer,
                from: modelInputRange,
                to: overlayViewFrame.size) ?? (Result(dots: [], lines: [], score: 0), Times(preprocessing: 0, inference: 0, postprocessing: 0))
        }
    }
    
}
