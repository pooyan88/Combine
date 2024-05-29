//
//  ViewController.swift
//  Combine Training
//
//  Created by Pooyan J on 10/26/1402 AP.
//

import Combine
import UIKit

class MyCustomCell: UITableViewCell {

    let button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemPink
        button.setTitle("button", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    let action = PassthroughSubject<String, Never>()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(button)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    @objc func didTapButton() {
        action.send("Button Was Tapped!")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        button.frame = CGRect(x: 10, y: 3, width: contentView.frame.size.width-20, height: contentView.frame.height-6)
    }
}

class ViewController: UIViewController, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyCustomCell
//        cell.textLabel?.text = companies[indexPath.row]
        cell.action.sink { passedValue in
            print(passedValue)
        }.store(in: &observers)
        return cell
    }
    
    private var companies: [String] = []
    var observers: [AnyCancellable] = []
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(MyCustomCell.self
                       , forCellReuseIdentifier: "cell")
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        print("pull request sent")
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.frame = view.bounds
        
        APICaller.shared.fetchComponies()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in
        }, receiveValue: { [weak self] values  in
            self?.companies = values
            self?.tableView.reloadData()
        }).store(in: &observers)
    }
}

