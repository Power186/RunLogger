//
//  CircleButton.swift
//  RunLogger
//
//  Created by Scott on 7/16/21.
//

import UIKit

final class CircularButton: UIButton {
    var borderWidth: CGFloat = 10.0
    var borderColor: UIColor = UIColor.white
    var setBackgroundColor: UIColor = UIColor.purple
    
    var titleText: String? {
        didSet {
            setTitle(titleText, for: .normal)
        }
    }
    
    var titleTextColor: UIColor? {
        didSet {
            setTitleColor(titleTextColor, for: .normal)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder) has not been implemented.")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setUp()
    }
    
    private func setUp() {
        clipsToBounds = true
        backgroundColor = setBackgroundColor
        layer.cornerRadius = frame.size.width / 2.0
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = borderWidth
    }
}
