//
//  HomeViewController.swift
//  RunLogger
//
//  Created by Scott on 7/15/21.
//

import UIKit
import MapKit

class HomeViewController: BaseViewController {

    // MARK: - UIElements
    
    private lazy var startButton: CircularButton = {
        let v = CircularButton()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.borderWidth = 15
        v.borderColor = #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1)
        v.setBackgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        v.titleText = "RUN"
        v.addTarget(self, action: #selector(startRunning), for: .touchUpInside)
        return v
    }()
    
    private lazy var topLabel: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.text = "Run Logger"
        v.textAlignment = .center
        v.textColor = #colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1)
        v.font = v.font.withSize(32)
        return v
    }()
    
    private lazy var mapView: MKMapView = {
        let v = MKMapView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.alpha = 0.6
        v.delegate = self
        return v
    }()
    
    // MARK: - Local variables
    
    private var locationManager = LocationManager()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }

    // MARK: - Helpers
    
    @objc private func startRunning() {
        let currentRunVC = CurrentRunViewController()
        currentRunVC.modalPresentationStyle = .fullScreen
        present(currentRunVC, animated: true, completion: nil)
    }
    
    private func setupViews() {
        locationManager.checkLocationAuthorization()
        view.addSubview(topLabel)
        view.addSubview(mapView)
        view.addSubview(startButton)
    }
    
    private func setupConstraints() {
        // top label
        NSLayoutConstraint.activate([
            topLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
        // map view
        NSLayoutConstraint.activate([
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 8),
            mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        // start button
        NSLayoutConstraint.activate([
            startButton.widthAnchor.constraint(equalToConstant: 100),
            startButton.heightAnchor.constraint(equalToConstant: 100),
            startButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
}


// MARK: - Extension

extension HomeViewController: MKMapViewDelegate {
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
    }
    
}
