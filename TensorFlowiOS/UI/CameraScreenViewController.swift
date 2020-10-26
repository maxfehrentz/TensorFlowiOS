//
//  ViewController.swift
//  TensorFlowiOS
//
//  Created by Max on 29.09.20.
//

import UIKit
import SnapKit
import os
import Flutter

class CameraScreenViewController: UIViewController {
    
    let previewView = PreviewView()
    let overlayView = OverlayView()
    private var viewModel: CameraScreenViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        layoutSubviews()
        configureSubviews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel = CameraScreenViewModel(cameraScreenDelegate: self)
    }
    
    private func addSubviews() {
        view.addSubview(previewView)
        view.addSubview(overlayView)
    }
    
    private func layoutSubviews() {
        previewView.snp.makeConstraints { (make) in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        overlayView.snp.makeConstraints { (make) in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func configureSubviews() {
        overlayView.backgroundColor = UIColor.clear
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.stopSession()
    }
}
