//
//  ForgotPasswordVC.swift
//  skillCounter
//
//  Created by 田中江樹 on 2017-04-20.
//  Copyright © 2017 Koki. All rights reserved.
//

import UIKit
import MessageUI

class ForgotPasswordVC: UIViewController, UITextFieldDelegate, MFMailComposeViewControllerDelegate {
    
    var container: UIView = {
        let v = UIView(frame: CGRect(x:0, y:0, width:300, height:300))
        v.backgroundColor = uiColor(89, 79, 194, 0.5)
        v.layer.cornerRadius = 10
        return v
    }()
    
    var message1: UILabel = {
        let mes = UILabel(frame: CGRect(x: 10, y: 70, width: 280, height: 20))
        mes.font = UIFont(name: "AvenirNext-DemiBold", size: 15)
        mes.textColor = .white
        mes.textAlignment = .center
        mes.text = "Type your email and we'll"
        return mes
    }()
    
    var message2: UILabel = {
        let mes = UILabel(frame: CGRect(x: 10, y: 90, width: 280, height: 20))
        mes.font = UIFont(name: "AvenirNext-DemiBold", size: 15)
        mes.textColor = .white
        mes.textAlignment = .center
        mes.text = "send you the password."
        return mes
    }()
    
    var email: MyTextField = {
        let email = MyTextField(frame: CGRect(x: 10, y: 130, width: 280, height: 40))
        email.backgroundColor = .white
        email.placeholder = "Enter your email address"
        email.keyboardType = .emailAddress
        email.font = UIFont(name: "AvenirNext-DemiBold", size: 14)
        email.layer.cornerRadius = 8
        email.layer.masksToBounds = true
        return email
    }()
    var forgotEmail = ""
    var forgotUsername = ""
    var forgotPassword = ""
    var errorType = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background_1.jpg")
        self.view.insertSubview(backgroundImage, at: 0)
        
        self.view.addSubview(self.container)
        
        let circleImage = UIImageView(frame: CGRect(x: self.container.frame.midX - 20, y: 10, width: 40 , height: 40 ))
        circleImage.backgroundColor = .white
        circleImage.layer.cornerRadius = 20
        circleImage.clipsToBounds = true
        circleImage.image = #imageLiteral(resourceName: "help.png")
        circleImage.contentMode = .scaleToFill
        self.container.addSubview(circleImage)
        
        self.container.addSubview(self.email)
        textFieldDidBeginEditing(email)
        self.container.addSubview(self.message1)
        self.container.addSubview(self.message2)
        
        let btnSend = UIButton(frame: CGRect(x: 110, y: 190, width: 80, height: 40))
        btnSend.setTitle("SEND", for: .normal)
        btnSend.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 16)
        btnSend.setBackgroundImage(UIImage(color: uiColor(119, 109, 169, 0.9)), for: .normal)
        btnSend.addTarget(self, action: #selector(sendAction), for: .touchUpInside)
        self.container.addSubview(btnSend)
        
        let btnNormalLogin = UIButton(frame: CGRect(x: 10, y: 260, width: 70, height: 40))
        btnNormalLogin.setTitle("RETURN", for: .normal)
        btnNormalLogin.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 16)
        btnNormalLogin.setBackgroundImage(UIImage(color: uiColor(19, 79, 129, 0.9)), for: .highlighted)
        btnNormalLogin.addTarget(self, action: #selector(normalLoginAction), for: .touchUpInside)
        self.container.addSubview(btnNormalLogin)
        
        self.container.center = self.view.center
        
        //dismiss keyboard when touching anywhere outside UITextField and pressing return
        self.hideKeyboard()
        email.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(_:)), name: .UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide(_:)), name: .UIKeyboardDidHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
    }
    
    
    func keyboardDidShow(_ note: Notification) {
        UIView.animate(withDuration: 0.2, animations: {
            let registerBtnBottomEdge = self.container.frame.origin.y + 270 + 40
            let moveDistance = registerBtnBottomEdge - MyVar.keyboardTopEdge + 10
            print("loginBtnBottomEdge=\(registerBtnBottomEdge) keyboardTopEdge=\(MyVar.keyboardTopEdge)")
            if moveDistance > 0 {
                self.container.frame.origin.y -= moveDistance
            }
        })
    }
    
    func keyboardDidHide(_ note: Notification) {
        UIView.animate(withDuration: 0.2, animations: {
            self.container.center = self.view.center
        })
    }
    
    func keyboardWillShow(_ note: NSNotification) {
        let userInfo:NSDictionary = note.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        MyVar.keyboardTopEdge = self.view.frame.height - keyboardHeight
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textFieldDidBeginEditing(_ textField : UITextField)
    {
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.spellCheckingType = .no
    }
    
    
    func normalLoginAction() {
        self.dismiss(animated: false, completion: nil)
    }
    
    func sendAction() {
        errorType = 0
        forgotEmail = ""
        forgotPassword = ""
        forgotUsername = ""
        if email.text == "" {
            showAlert(title: "Error", message: "Enter your email address!!")
        } else if !(email.text?.contains("@"))! || !(email.text?.contains("."))! {
            showAlert(title: "Error!", message: "Incorrect email format!")
        } else {
            let url = URL(string: "http://headspinnerd-com.stackstaging.com/bboying/emailGet.php")
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            
            var request = URLRequest(url: url!)
            request.httpMethod = "POST"
            
            let body = "email=\(self.email.text!)"
            print("body=\(body)")
            
            request.httpBody = body.data(using: String.Encoding.utf8)
            
            let task = session.dataTask(with: request) {
                data, response, error in
                
                if error != nil {
                    if error!.localizedDescription == "The Internet connection appears to be offline." {
                        self.errorType = 1
                    } else {
                        print("error=\(error!.localizedDescription)")
                        self.errorType = 2
                    }
                } else {
                    do {
                        let json: Any? = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                        if let result_list = json as? NSArray
                        {
                            if result_list.count > 0 {
                                for var i in 0...result_list.count-1
                                {
                                    if let result_obj = result_list[i] as? NSDictionary
                                    {
                                        if let address = result_obj["email"] as? String
                                        {
                                            self.forgotEmail = address
                                            if let username = result_obj["username"] as? String
                                            {
                                                self.forgotUsername = username
                                                if let password = result_obj["password"] as? String
                                                {
                                                    self.forgotPassword = password
                                                }
                                            }
                                        }
                                    }
                                    i += 1
                                }
                            }
                        }
                        self.sendEmail()
                    } catch {
                        print("error in JSONSerialization")
                    }
                }
            }
            task.resume()
        }
    }
    
    
    func sendEmail() {
        DispatchQueue.main.async(execute: {
            if self.forgotEmail != "" {
                //self.resignFirstResponder()
                
                let urlString: String = "http://headspinnerd-com.stackstaging.com/bboying/password_send.php"
                let post: String = "forgotUsername=\(self.forgotUsername)&forgotPassword=\(self.forgotPassword)&email=\(self.forgotEmail)"
                let parsedData: String? = HttpRequestController().sendPostRequestSynchronous2(urlString: urlString, post: post)
                print("parseData=\(String(describing: parsedData))")
                if let _parsedData = parsedData {
                    if updateResCheck(response: _parsedData) {
                        self.showAlert(title: "Forgot Password", message: "Please check your email inbox to see the password!")
                    } else {
                        self.showAlert(title: "Forgot Password", message: "Failed. Please check your email address.")
                    }
                } else {
                    self.showAlert(title: "Forgot Password", message: "Failed. Please check your email address.")
                }
                
            } else {
                switch self.errorType {
                case 1: self.showAlert(title: "Error", message: "The Internet connection appears to be offline."); return
                case 2: self.showAlert(title: "Error", message: "Unknow Error."); return
                default: self.showAlert(title: "Error!", message: "There is no user registered with that address!", style: .alert) ; return
                }
            }
        })
    }
    
    //dismiss keyboard when pressing return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func showAlert(title: String, message: String? = nil, style: UIAlertControllerStyle = .alert) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}


