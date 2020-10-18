//
//  ViewController.swift
//  AccessibleProgressBar
//
//  Created by Anurag Ajwani on 18/10/2020.
//

import UIKit

class ViewController: UIViewController {

    private weak var progressBarView: ProgressBarView!
    private weak var uploadButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addProgressBarView()
        self.addUploadButton()
    }
    
    private func addProgressBarView() {
        let progressBarView = ProgressBarView(frame: CGRect.zero)
        progressBarView.translatesAutoresizingMaskIntoConstraints = false
        progressBarView.backgroundColor = UIColor.systemTeal
        progressBarView.progressColor = UIColor.systemBlue
        self.view.addSubview(progressBarView)
        self.progressBarView = progressBarView
        NSLayoutConstraint.activate([
            self.progressBarView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.progressBarView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.progressBarView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8),
            self.progressBarView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.05)
        ])
    }
    
    private func addUploadButton() {
        let uploadButton = UIButton()
        uploadButton.translatesAutoresizingMaskIntoConstraints = false
        uploadButton.setTitle("Upload", for: .normal)
        uploadButton.addTarget(self, action: #selector(self.didTapUploadButton), for: .touchUpInside)
        uploadButton.setTitleColor(.blue, for: .normal)
        uploadButton.setTitleColor(.gray, for: .disabled)
        self.view.addSubview(uploadButton)
        self.uploadButton = uploadButton
        NSLayoutConstraint.activate([
            self.uploadButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.uploadButton.topAnchor.constraint(equalTo: self.progressBarView.bottomAnchor, constant: 5)
        ])
    }
    
    @objc private func didTapUploadButton() {
        UIAccessibility.post(notification: .screenChanged, argument: self.progressBarView)
        self.uploadButton.isEnabled = false
        self.totalProgress = 0
        self.progressBarView.progress = 0.0
        self.updateProgress(onProgressCompleted: { self.uploadButton.isEnabled = true })
    }
    
    private var totalProgress: CGFloat = 0
    
    private func scheduleTimer(progress: CGFloat, onCompletion: @escaping () -> ()) {
        Timer.scheduledTimer(
            withTimeInterval: TimeInterval.random(in: 1...2),
            repeats: false,
            block: { _ in
                self.progressBarView.progress = progress
                onCompletion()
            })
    }
    
    private func updateProgress(onProgressCompleted: @escaping () -> ()) {
        guard totalProgress < 1 else {
            onProgressCompleted()
            return
        }
        self.addToProgress()
        self.scheduleTimer(progress: self.totalProgress, onCompletion: { self.updateProgress(onProgressCompleted: onProgressCompleted) })
    }
    
    private func addToProgress() {
        let rand = CGFloat.random(in: 0...1)
        self.totalProgress += rand
        if self.totalProgress > 1 {
            self.totalProgress = 1.0
        }
    }
}

