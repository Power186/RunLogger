//
//  HistoryViewController.swift
//  RunLogger
//
//  Created by Scott on 7/15/21.
//

import UIKit

class HistoryViewController: BaseViewController {
    
    private static let reuseId = "REUSEID"
    
    // MARK: - UI Elements
    private lazy var topLabel: UILabel = {
        let v = view.metricLabel(text: "Run Logs",
                                 color: #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1),
                                 fontSize: 32,
                                 weight: .regular)
        v.textAlignment = .center
        return v
    }()
    
    private lazy var tableView: UITableView = {
       let v = UITableView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.delegate = self
        v.dataSource = self
        v.register(HistoryTableViewCell.self, forCellReuseIdentifier: Self.reuseId)
        v.backgroundColor = .clear
        v.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        v.separatorColor = .white
        return v
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }

    private func setupViews() {
        view.addSubview(topLabel)
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        // top label
        NSLayoutConstraint.activate([
            topLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
        // table view
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: topLabel.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
}

// MARK: - Extensions

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Run.getAllRuns()?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Self.reuseId) as? HistoryTableViewCell,
              let run = Run.getAllRuns()?[indexPath.row] else {
            return UITableViewCell()
        }
        
        cell.configure(run)
        return cell
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let run = Run.getAllRuns()?[indexPath.row] else { return }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = PreviousRunDetailViewController(run: run)
        present(vc, animated: true, completion: nil)
    }
    
}

