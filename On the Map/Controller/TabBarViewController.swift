//
//  TabBarViewController.swift
//  On the Map
//
//  Created by Ivan Zandonà on 09/11/2020.
//

import UIKit

class TabBarViewController: UITabBarController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func logout(_ sender: Any) {
        Client.logout(completion: { (error) in
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        })
    }
    
    @IBAction func refreshData(_ sender: Any) {
        Client.getStudentLocations(completion: { (studentInformation, error) in
            StudentLocationModel.locations = studentInformation
        })
    }
    
}
