//
//  ViewController.swift
//  TensorFlowiOS
//
//  Created by Max on 29.09.20.
//

import UIKit
import SnapKit
import os

class CameraScreenViewController: UIViewController {
    
    let previewView = PreviewView()
    let overlayView = OverlayView()
    private var viewModel: CameraScreenViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        layoutSubviews()
        configureSubviews()
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.startSession()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        viewModel.stopSession()
    }
}
