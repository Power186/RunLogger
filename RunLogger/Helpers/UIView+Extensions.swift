//
//  UIView+Extensions.swift
//  RunLogger
//
//  Created by Scott on 7/16/21.
//

import UIKit

extension UIView {
    
    func metricLabel(text: String, color: UIColor, fontSize: CGFloat, weight: UIFont.Weight) -> UILabel {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.text = text
        v.textColor = color
        v.font = UIFont.systemFont(ofSize: fontSize, weight: weight)
        return v
    }
    
    func metricStackView(subviews: [UIView]) -> UIStackView {
        let v = UIStackView(arrangedSubviews: subviews)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.alignment = .center
        v.axis = .vertical
        v.distribution = .equalSpacing
        return v
    }
    
    func capsuleView() -> UIView {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        v.layer.cornerRadius = 35
        v.layer.masksToBounds = true
        return v
    }
    
    func stopSliderKnob() -> UIImageView {
        let v = UIImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.isUserInteractionEnabled = true
        v.image = UIImage(systemName: "arrow.left.and.right.circle")
        v.tintColor = .white
        v.layer.borderColor = UIColor.white.cgColor
        v.layer.borderWidth = 5
        v.layer.cornerRadius = 25
        v.layer.masksToBounds = true
        return v
    }
    
    func sliderStop() -> UIImageView {
        let v = UIImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.image = UIImage(systemName: "stop.circle.fill")
        v.tintColor = .white
        v.layer.borderColor = UIColor.clear.withAlphaComponent(0.5).cgColor
        v.layer.borderWidth = 5
        v.layer.cornerRadius = 35
        v.layer.masksToBounds = true
        return v
    }
    
}
