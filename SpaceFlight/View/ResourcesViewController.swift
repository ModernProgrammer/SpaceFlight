//
//  ResourcesViewController.swift
//  SpaceFlight
//
//  Created by Diego Bustamante on 10/17/21.
//

import UIKit

class ResourcesViewController: UITableViewController {
    let navigationTitle = "Resources"
    let cellId = "cellId"
    let resources = [
        Resource(title: "Documentation", url: "https://api.spaceflightnewsapi.net/v3/documentation", image: "book"),
        Resource(title: "GitHub", url: "https://github.com/ModernProgrammer", image: "keyboard"),
        Resource(title: "Medium", url: "https://medium.com/@diegobustamante", image: "m.circle"),
        Resource(title: "Dribbble", url: "https://dribbble.com/diegoebustamante", image: "scribble.variable")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar(largeTitles: true, title: navigationTitle)
        setupTableView()
    }
}

// MARK: - UI Functions
extension ResourcesViewController {
    func setupTableView() {
        tableView.register(ResourceCell.self, forCellReuseIdentifier: cellId)
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.alwaysBounceVertical = true
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resources.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ResourceCell
        cell.resourceRow.resourceCellRowViewModel.resource = resources[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let url = URL(string: resources[indexPath.row].url) {
            UIApplication.shared.open(url)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}
