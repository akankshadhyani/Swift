//
//  ViewController.swift
//  MiniApp
//
//  Created by Akanksha Dhyani on 09/02/19.
//  Copyright © 2019 Akanksha Dhyani. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
class ViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    var serviceObject = Service()
    override func viewDidLoad() {
        super.viewDidLoad()
        username.delegate = self
        password.delegate = self
    }
    func showAlert(show msg: String) {
        let alert = UIAlertController(title: "PetInterest", message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    @IBAction func checkButton(_ sender: UIButton) {
         if sender.isSelected == true {
            sender.setBackgroundImage(UIImage(named: "unchecked.png"), for: .normal)
            sender.isSelected = false }
        else {
            sender.setBackgroundImage(UIImage(named: "checked.jpg"), for: .selected)
            sender.isSelected = true }
    }
    func validate() -> Bool {
        if (username.text?.isEmpty)! {
            if (password.text?.isEmpty)! {
                showAlert(show: "Credentials required")
                return false }
            else {
                showAlert(show: "Username required")
                return false } }
        else if (password.text?.isEmpty)! {
            showAlert(show: "Password required")
            return false }
        else if checkButton.isSelected == false {
            showAlert(show: "Agree to terms")
            return false }
        else {
            return true
        }
    }
    @IBAction func onPress(_ sender: Any) {
        if validate() {
            let setUser: String = username.text!
            let setPassword: String = password.text!
            let parameters: Parameters = ["username": setUser, "password": setPassword]
            let serviceObject = Service()
            
            serviceObject.postType(append: "login", use: parameters) {(userObject) in
                if userObject.response?.status?.code! == 200 {
                    let token = userObject.response?.data?.token
                    UserDefaults.standard.set(token, forKey: "usertoken")
                    self.performSegue(withIdentifier: "segway", sender: self)
                }
                else {
                    self.showAlert(show: "User not found!")
                }
            }
        }
    }
   @IBAction func infoButton(_ sender: Any) {}
}
