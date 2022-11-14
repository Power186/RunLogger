//
//  HistoryTableViewCell.swift
//  RunLogger
//
//  Created by Scott on 7/17/21.
//

import UIKit

final class HistoryTableViewCell: UITableViewCell {
    
    // MARK: - External properties
    
    var totalMiles: Double = 0.0 {
        didSet {
            totalTimeLabel.text = String(format: "%0.2f", totalMiles)
            layoutIfNeeded()
        }
    }
    
    var totalTime: String = "00:00:00" {
        didSet {
            totalTimeLabel.text = totalTime
            layoutIfNeeded()
        }
    }
    
    var entryDate: String = "04/01/2021" {
        didSet {
            entryDateLabel.text = entryDate
            layoutIfNeeded()
        }
    }
    
    // MARK: - UI Elements
    
    private lazy var totalMilesLabel: UILabel = {
        let v = contentView.metricLabel(text: "0.0",
                                        color: .white,
                                        fontSize: 24,
                                        weight: .bold)
        return v
    }()
    
    private lazy var totalTimeLabel: UILabel = {
        let v = contentView.metricLabel(text: "0.0",
                                        color: .white,
                                        fontSize: 18,
                                        weight: .regular)
        return v
    }()
    
    private lazy var entryDateLabel: UILabel = {
        let v = contentView.metricLabel(text: "0.0",
                                        color: .white,
                                        fontSize: 18,
                                        weight: .regular)
        return v
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = UIColor.black.withAlphaComponent(0.1)
        contentView.addSubview(totalMilesLabel)
        contentView.addSubview(totalTimeLabel)
        contentView.addSubview(entryDateLabel)
    }
    
    private func setupConstraints() {
        // total miles label
        NSLayoutConstraint.activate([
            totalMilesLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            totalMilesLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16)
        ])
        // total time label
        NSLayoutConstraint.activate([
            totalTimeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            totalTimeLabel.topAnchor.constraint(equalTo: totalMilesLabel.bottomAnchor, constant: 8),
            totalTimeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
        // entry date label
        NSLayoutConstraint.activate([
            entryDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            entryDateLabel.centerYAnchor.constraint(equalTo: totalMilesLabel.centerYAnchor)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
    }
    
    func configure(_ run: Run) {
        totalMiles = run.distance.meterToMiles()
        totalTime = run.duration.formatTimeString()
        entryDate = run.date.getDateString()
    }
    
}
