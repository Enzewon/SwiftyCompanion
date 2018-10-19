//
//  ViewController.swift
//  SwiftyCompanion
//
//  Created by Danil Vdovenko on 1/27/18.
//  Copyright © 2018 Danil Vdovenko. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textField: UITextField!
    
    var token: String?
    var searchedStudent: Student?
    var request = Request(key: "", secret: "")
    let alert = UIAlertController(title: "Error", message: "Invalid Username", preferredStyle: UIAlertControllerStyle.alert)
    let alert2 = UIAlertController(title: "Error", message: "Empty field, type something", preferredStyle: UIAlertControllerStyle.alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        request.basicRequest()
        
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
        alert2.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        self.textField.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        searchButton(UITextField.self)
        return false
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= 60
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y += 60
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC: ProfileTableViewController = segue.destination as! ProfileTableViewController
        
        destVC.student = self.searchedStudent
    }
    
    @IBAction func searchButton(_ sender: Any) {
        self.view.endEditing(true)
        if (textField.text?.isEmpty)! {
            self.present(self.alert2, animated: true, completion: nil)
        } else {
            if let username = textField.text?.trimmingCharacters(in: .whitespaces) {
                if username.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) != nil || username == "" {
                    self.present(self.alert, animated: true, completion: nil)
                } else {
                    print("Input login: \(username)")
                    if let token = self.request.token {
                        self.request.getUser(token: token, about: username, addUser: { (response, error) in
                            if let error = error {
                                print(error.localizedDescription)
                            }
                            if let response = response {
                                if !response.isEmpty {
                                    self.searchedStudent = self.request.setStudent(response: response)
                                    DispatchQueue.main.async {
                                        self.textField.text = ""
                                        self.performSegue(withIdentifier: "ProfileView", sender: self)
                                    }
                                }
                                else {
                                    DispatchQueue.main.async { [weak self] in
                                        self?.present((self?.alert)!, animated: true, completion: nil)
                                    }
                                }
                            }
                        })
                    }
                }
            }
        }
    }

}

extension UIViewController {

    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }

}
