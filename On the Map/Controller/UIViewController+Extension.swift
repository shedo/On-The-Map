//
//  UIViewController+Extension.swift
//  On the Map
//
//  Created by Ivan Zandonà on 10/11/2020.
//

import Foundation
import UIKit

extension UIViewController {
    
    static var spinner: UIActivityIndicatorView?
    
    func showAlertDialog(title:String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true, completion:nil)
    }
    
    func showLoader(show: Bool) {
        if show {
            UIViewController.spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
            UIViewController.spinner?.center = view.center
            UIViewController.spinner?.hidesWhenStopped = false
            UIViewController.spinner?.startAnimating()
            
            if let spinner = UIViewController.spinner {
                view.addSubview(spinner)
            }
        } else {
            UIViewController.spinner?.removeFromSuperview()
        }
    }
    
}
