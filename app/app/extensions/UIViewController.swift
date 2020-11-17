//
//  UIViewController.swift
//  app
//
//  Created by Sergey Romanenko on 14.11.2020.
//

import UIKit

extension UIViewController{
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        view.snapshotView(afterScreenUpdates: true)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func createSpinnerView() {
        let child = activityIndicator()
        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }
    }
    
    class activityIndicator: UIViewController {
        var spinner = UIActivityIndicatorView()
        override func loadView() {
            view = UIView()
            view.backgroundColor = .clear
            spinner.translatesAutoresizingMaskIntoConstraints = false
            spinner.startAnimating()
            view.addSubview(spinner)
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        }
    }
}
