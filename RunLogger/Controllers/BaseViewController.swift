//
//  HomeViewController.swift
//  RunLogger
//
//  Created by Scott on 7/15/21.
//

import UIKit

class BaseViewController: UIViewController {
    
    private lazy var backgroundLayer: GradientView = {
        let view = GradientView(colors: [#colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1), #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)])
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        view.addSubview(backgroundLayer)
    }
    
    private func setupConstraints() {
        // background layer
        NSLayoutConstraint.activate([
            backgroundLayer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundLayer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundLayer.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundLayer.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

}
