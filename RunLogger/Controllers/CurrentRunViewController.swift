//
//  CurrentRunViewController.swift
//  RunLogger
//
//  Created by Scott on 7/16/21.
//

import UIKit
import CoreLocation
import RealmSwift
import ShimmerSwift

class CurrentRunViewController: BaseViewController {

    // MARK: - UI Elements
    
    private static let titleFontSize: CGFloat = 32
    private static let subTitleFontSize: CGFloat = 24
    
    private lazy var topLabel: UILabel = {
        let v = view.metricLabel(text: "Running..",
                                 color: .darkGray,
                                 fontSize: Self.titleFontSize,
                                 weight: .regular)
        v.textAlignment = .center
        return v
    }()
    
    private lazy var timeLabel: UILabel = {
        return view.metricLabel(text: "00:00:00",
                                color: .white,
                                fontSize: Self.subTitleFontSize,
                                weight: .bold)
    }()
    
    private lazy var paceTitleLabel: UILabel = {
        return view.metricLabel(text: "Average Pace",
                                         color: .white,
                                         fontSize: Self.subTitleFontSize,
                                         weight: .regular)
    }()
    
    private lazy var paceLabel: UILabel = {
        return view.metricLabel(text: "0:00",
                                color: .white,
                                fontSize: Self.titleFontSize,
                                weight: .bold)
    }()
    
    private lazy var paceSubTitleLabel: UILabel = {
        return view.metricLabel(text: "/mi",
                                color: .white,
                                fontSize: Self.subTitleFontSize,
                                weight: .regular)
    }()
    
    private lazy var paceStackView: UIStackView = {
        return view.metricStackView(subviews: [paceTitleLabel, paceLabel, paceSubTitleLabel])
    }()
    
    private lazy var distanceTitleLable: UILabel = {
        return view.metricLabel(text: "Distance",
                                color: .white,
                                fontSize: Self.subTitleFontSize,
                                weight: .regular)
    }()
    
    private lazy var distanceLabel: UILabel = {
        return view.metricLabel(text: "0.0",
                                color: .white,
                                fontSize: Self.subTitleFontSize,
                                weight: .regular)
    }()
    
    private lazy var distanceSubTitleLabel: UILabel = {
        return view.metricLabel(text: "mi",
                                color: .white,
                                fontSize: Self.titleFontSize,
                                weight: .bold)
    }()
    
    private lazy var distanceStackView: UIStackView = {
        return view.metricStackView(subviews: [distanceTitleLable, distanceLabel, distanceSubTitleLabel])
    }()
    
    private lazy var pageStackView: UIStackView = {
        let v = view.metricStackView(subviews: [timeLabel, paceStackView, distanceStackView])
        v.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        return v
    }()
    
    private lazy var sliderView: UIView = {
        return view.capsuleView()
    }()
    
    private lazy var stopSliderKnob: UIImageView = {
        return view.stopSliderKnob()
    }()
    
    private lazy var sliderStop: UIImageView = {
        return view.sliderStop()
    }()
    
    private lazy var sliderText: UILabel = {
        let v = view.metricLabel(text: "Slide to stop",
                                 color: .white,
                                 fontSize: Self.subTitleFontSize,
                                 weight: .regular)
        return v
    }()
    
    private lazy var sliderShimmer: ShimmeringView = {
        let v = ShimmeringView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.shimmerSpeed = 1
        v.shimmerPauseDuration = 2
        return v
    }()
    
    // MARK: - Local variables
    
    private var startLocation: CLLocation!
    private var endLocation: CLLocation!
    
    private var runDistance = 0.0
    private var timeElapsed = 0
    private var pace = 0
    fileprivate var coordLocations = List<Location>()
    
    private var locationManager = LocationManager()
    
    private var timer = Timer()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setUpConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationManager.manager.delegate = self
        startRunning()
        sliderBounceAnimation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        stopRun()
        super.viewWillDisappear(animated)
    }
    
    private func setUpViews() {
        view.addSubview(topLabel)
        view.addSubview(pageStackView)
        view.addSubview(sliderView)
        sliderView.addSubview(stopSliderKnob)
        sliderView.addSubview(sliderStop)
        sliderView.addSubview(sliderText)
        sliderView.addSubview(sliderShimmer)
        
        sliderShimmer.contentView = sliderText
        sliderShimmer.isShimmering = true
        
        let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(dismissEnd(sender:)))
        stopSliderKnob.addGestureRecognizer(swipeGesture)
    }
    
    private func setUpConstraints() {
        // top label
        NSLayoutConstraint.activate([
            topLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
        // page stackview
        NSLayoutConstraint.activate([
            pageStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageStackView.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 8),
        ])
        // capsule view
        NSLayoutConstraint.activate([
            sliderView.widthAnchor.constraint(equalToConstant: 300),
            sliderView.heightAnchor.constraint(equalToConstant: 70),
            sliderView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            sliderView.topAnchor.constraint(equalTo: pageStackView.bottomAnchor, constant: 8),
            sliderView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        // slider stop knob
        NSLayoutConstraint.activate([
            stopSliderKnob.leadingAnchor.constraint(equalTo: sliderView.leadingAnchor, constant: 8),
            stopSliderKnob.centerYAnchor.constraint(equalTo: sliderView.centerYAnchor),
            stopSliderKnob.widthAnchor.constraint(equalToConstant: 50),
            stopSliderKnob.heightAnchor.constraint(equalToConstant: 50)
        ])
        // slider stop image
        NSLayoutConstraint.activate([
            sliderStop.trailingAnchor.constraint(equalTo: sliderView.trailingAnchor),
            sliderStop.centerYAnchor.constraint(equalTo: sliderView.centerYAnchor),
            sliderStop.widthAnchor.constraint(equalToConstant: 70),
            sliderStop.heightAnchor.constraint(equalToConstant: 70)
        ])
        
        // slider text
        NSLayoutConstraint.activate([
            sliderText.centerXAnchor.constraint(equalTo: sliderView.centerXAnchor),
            sliderText.centerYAnchor.constraint(equalTo: sliderView.centerYAnchor)
        ])
        
        // shimmer
        NSLayoutConstraint.activate([
            sliderShimmer.leadingAnchor.constraint(equalTo: sliderView.leadingAnchor, constant: 75),
            sliderShimmer.trailingAnchor.constraint(equalTo: sliderView.trailingAnchor, constant: -75),
            sliderShimmer.topAnchor.constraint(equalTo: sliderView.topAnchor),
            sliderShimmer.bottomAnchor.constraint(equalTo: sliderView.bottomAnchor)
        ])
    }
    
    private func startRunning() {
        locationManager.manager.startUpdatingLocation()
        startTimer()
    }
    
    private func stopRun() {
        locationManager.manager.stopUpdatingLocation()
        stopTimer()
    }
    
    private func startTimer() {
        timeLabel.text = timeElapsed.formatTimeString()
        timer = Timer.scheduledTimer(timeInterval: 1.0,
                                     target: self,
                                     selector: #selector(updateTimer),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    private func stopTimer() {
        timer.invalidate()
        timeElapsed = 0
    }
    
    @objc private func updateTimer() {
        timeElapsed += 1
        timeLabel.text = timeElapsed.formatTimeString()
    }
    
    private func computePace(time seconds: Int, miles: Double) -> String {
        pace = Int(Double(seconds) / miles)
        return pace.formatTimeString()
    }
    
    @objc private func dismissEnd(sender: UIPanGestureRecognizer) {
        let adjust: CGFloat = 35
        let translation = sender.translation(in: view)
        
        if sender.state == .began || sender.state == .changed {
            if stopSliderKnob.center.x > sliderStop.center.x {
                stopSliderKnob.center.x = sliderStop.center.x
                
                let timeElapsed = self.timeElapsed
                stopRun()
                
                Run.addRunToRealm(pace: pace,
                                  distance: runDistance,
                                  duration: timeElapsed,
                                  locations: coordLocations)
                
                dismiss(animated: true, completion: nil)
            } else if stopSliderKnob.center.x < sliderView.bounds.minX + adjust {
                stopSliderKnob.center.x = sliderView.bounds.minX + adjust
            } else {
                stopSliderKnob.center.x += translation.x
            }
            sender.setTranslation(.zero, in: view)
        } else if sender.state == .ended && stopSliderKnob.center.x < sliderStop.center.x {
            UIView.animate(withDuration: 0.5) {
                self.stopSliderKnob.center.x = self.sliderView.bounds.minX + adjust
            }
        }
    }
    
    private func sliderBounceAnimation() {
        UIView.animate(withDuration: 0.5) {
            self.stopSliderKnob.center.x += 100
        } completion: { _ in
            UIView.animate(withDuration: 1,
                           delay: 0.1,
                           usingSpringWithDamping: 0.5,
                           initialSpringVelocity: 0.1,
                           options: .curveEaseInOut) {
                self.stopSliderKnob.center.x -= 100
            } completion: { _ in }

        }
    }
    
}


// MARK: - Extensions

extension CurrentRunViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if startLocation == nil {
            startLocation = locations.first
        } else if let location = locations.last {
            runDistance += endLocation.distance(from: location)
            
            let newLocation = Location(lat: Double(endLocation.coordinate.latitude),
                                       long: Double(endLocation.coordinate.longitude))
            coordLocations.insert(newLocation, at: 0)
            
            self.distanceLabel.text = self.runDistance.meterToMiles().toString(places: 2)
            
            if timeElapsed > 0 && runDistance > 0 {
                paceLabel.text = computePace(time: timeElapsed, miles: runDistance.meterToMiles())
            }
        }
        endLocation = locations.last
    }
}
