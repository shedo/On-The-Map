//
//  TableTabbedViewController.swift
//  On the Map
//
//  Created by Ivan Zandonà on 09/11/2020.
//

import UIKit

class TableTabbedViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var selectedIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension TableTabbedViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentLocationModel.locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableTabViewCell")!
        
        let location = StudentLocationModel.locations[indexPath.row]
        
        cell.textLabel?.text = "\(location.firstName) \(location.lastName)"
        cell.detailTextLabel?.text = location.mediaURL
        cell.imageView?.image = UIImage(named: "icon_pin")
                
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let location = StudentLocationModel.locations[indexPath.row]
        UIApplication.shared.open(URL(string: location.mediaURL)!, options: [:], completionHandler: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
