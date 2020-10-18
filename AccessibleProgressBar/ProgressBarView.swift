//
//  ProgressBarView.swift
//  AccessibleProgressBar
//
//  Created by Anurag Ajwani on 18/10/2020.
//

import Foundation
import UIKit

class ProgressBarView: UIView {

    var progress: CGFloat = 0.0 {
        didSet {
            self.setNeedsDisplay()
            let progressString = "\(Int(self.progress * 100))%"
            self.accessibilityValue = progressString
            UIAccessibility.post(notification: .announcement, argument: progressString)
        }
    }

    var progressColor: UIColor = .black {
        didSet {
            self.progressLayer.backgroundColor = self.progressColor.cgColor
        }
    }
    
    private let progressLayer = CALayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }

    private func commonInit() {
        self.layer.addSublayer(self.progressLayer)
        progressLayer.backgroundColor = UIColor.systemBlue.cgColor
        self.isAccessibilityElement = true
        self.accessibilityLabel = "progress bar"
    }

    override func draw(_ rect: CGRect) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = UIBezierPath(roundedRect: rect, cornerRadius: 5).cgPath
        layer.mask = shapeLayer
        let progressRect = CGRect(origin: .zero, size: CGSize(width: rect.width * self.progress, height: rect.height))
        self.progressLayer.frame = progressRect
    }
}
