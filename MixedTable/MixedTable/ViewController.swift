//
//  ViewController.swift
//  MixedTable
//
//  Created by Vadim Rufov on 11.9.2023.
//

import UIKit

final class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private lazy var button = {
        let view = UIButton()
        view.setTitle("Shuffle", for: .normal)
        view.setTitleColor(.systemBlue, for: .normal)
        
        view.addTarget(self, action: #selector(self.shuffleRows), for: [.touchUpInside, .touchUpOutside])
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return view
    }()
    
    private lazy var tableViewData: [Value] = [Value]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupData()
    }
    
    private func setupViews() {
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(button)
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let margins = view.layoutMarginsGuide
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: margins.topAnchor, constant: 6),
            button.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: 6),
            
            tableView.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
    }
    
    private func setupData() {
        for i in 0...29 {
            tableViewData.append(Value(number: i))
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = .none
        let value = tableViewData[indexPath.row]
        cell.accessoryType = value.marked ? .checkmark : .none
        cell.textLabel?.text = String(value.number + 1)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int { 1 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 30 }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        
        switch cell.accessoryType {
        case .none:
            cell.accessoryType = .checkmark
            tableViewData.insert(tableViewData.remove(at: indexPath.row), at: 0)
            tableViewData[0].marked = true
            UIView.animate(withDuration: 0.2) {
                tableView.moveRow(at: indexPath, to: IndexPath(row: 0, section: indexPath.section))
            }
        default:
            cell.accessoryType = .none
        }
    }
    
    @objc private func shuffleRows(){
        let newOrder = Set(0...29)
        for (oldPosition, newPosition) in newOrder.enumerated() {
            self.tableViewData.insert(self.tableViewData.remove(at: oldPosition), at: newPosition)
            self.tableView.moveRow(
                at: IndexPath(row: oldPosition, section: 0),
                to: IndexPath(row: newPosition, section: 0)
            )
        }
    }
}

struct Value {
    let number: Int
    var marked: Bool = false
}
