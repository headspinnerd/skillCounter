//
//  RegisterViewController.swift
//  skillCounter
//
//  Created by 田中江樹 on 2017-03-12.
//  Copyright © 2017 Koki. All rights reserved.
//

import UIKit

protocol RegisterViewControllerDelegate {
    func didLoginSuccessfully()
}

class RegisterViewController: UIViewController, UITextFieldDelegate {

    var delegate: RegisterViewControllerDelegate?
    
    var container: UIView = {
        let v = UIView(frame: CGRect(x:0, y:0, width:300, height:350))
        v.backgroundColor = UIColor(red: 89/255, green: 79/255, blue: 194/255, alpha: 0.5)
        v.layer.cornerRadius = 10
        return v
    }()
    
    var username: MyTextField = {
        let name = MyTextField(frame: CGRect(x: 10, y: 80, width: 280, height: 40))
        name.backgroundColor = .white
        name.placeholder = "Username"
        name.font = UIFont(name: "AvenirNext-DemiBold", size: 14)
        name.layer.cornerRadius = 8
        name.layer.masksToBounds = true
        return name
    }()
    
    var email: MyTextField = {
        let email = MyTextField(frame: CGRect(x: 10, y: 140, width: 280, height: 40))
        email.backgroundColor = .white
        email.placeholder = "Email"
        email.keyboardType = .emailAddress
        email.font = UIFont(name: "AvenirNext-DemiBold", size: 14)
        email.layer.cornerRadius = 8
        email.layer.masksToBounds = true
        return email
    }()
    
    var password: MyTextField = {
        let pass = MyTextField(frame: CGRect(x: 10, y: 200, width: 280, height: 40))
        pass.backgroundColor = .white
        pass.placeholder = "Password"
        pass.font = UIFont(name: "AvenirNext-DemiBold", size: 14)
        pass.layer.cornerRadius = 8
        pass.layer.masksToBounds = true
        pass.isSecureTextEntry = true
        return pass
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "breakin.jpeg")
        self.view.insertSubview(backgroundImage, at: 0)
        
        self.view.addSubview(self.container)
        
        let circleImage = UIImageView(frame: CGRect(x: self.container.frame.midX - 30, y: 10, width: 60 , height: 60 ))
        circleImage.backgroundColor = .white
        circleImage.layer.cornerRadius = 30
        circleImage.clipsToBounds = true
        circleImage.image = #imageLiteral(resourceName: "username")
        self.container.addSubview(circleImage)
        
        self.container.addSubview(self.username)
        textFieldDidBeginEditing(username)
        self.container.addSubview(self.email)
        textFieldDidBeginEditing(email)
        self.container.addSubview(self.password)
        textFieldDidBeginEditing(password)
        
        let btnRegister = UIButton(frame: CGRect(x: 10, y: 270, width: 280, height: 40))
        btnRegister.setTitle("REGISTER", for: .normal)
        btnRegister.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 16)
        btnRegister.setBackgroundImage(UIImage(color: UIColor(red: 119/255, green: 109/255, blue: 169/255, alpha: 0.9)), for: .normal)
        btnRegister.addTarget(self, action: #selector(registerAction), for: .touchUpInside)
        self.container.addSubview(btnRegister)
        
        let btnLogin = UIButton(frame: CGRect(x: 230, y: 310, width: 70, height: 40))
        btnLogin.setTitle("LOGIN", for: .normal)
        btnLogin.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 16)
        btnLogin.setBackgroundImage(UIImage(color: UIColor(red: 19/255, green: 79/255, blue: 129/255, alpha: 0.9)), for: .highlighted)
        btnLogin.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
        self.container.addSubview(btnLogin)
    
        self.container.center = self.view.center
        
        //dismiss keyboard when touching anywhere outside UITextField and pressing return
        self.hideKeyboard()
        username.delegate = self
        email.delegate = self
        password.delegate = self
        
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

    func registerAction() {
        if username.text == "" || email.text == "" || password.text == "" { //FIXME: Should add error check
            let alertController = UIAlertController(title: "Error!", message: "Fill in all columns!!", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            })
            alertController.addAction(ok)
            self.present(alertController, animated: true, completion: nil)
        } else {
            let request = NSMutableURLRequest(url: NSURL(string: "http://headspinnerd.000webhostapp.com/bboying/register.php")! as URL)
            request.httpMethod = "POST"
            let postString = "username=\(username.text!)&email=\(email.text!)&password=\(password.text!)"
            
            request.httpBody = postString.data(using: String.Encoding.utf8)
            
            let task = URLSession.shared.dataTask(with: request as URLRequest) {
                data, response, error in
                
                if error != nil {
                    print("error=\(error)")
                    return
                }
                
                print("response = \(response)")
                
                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                print("responseString = \(responseString)")
            }
            task.resume()
            
            // FIXME: Need to check if the username already exist or not
            let alertController = UIAlertController(title: "Update", message:
                "Successfully Updated", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: { (action: UIAlertAction!) in
                /*sleep(3)
                self.resignFirstResponder()
                self.delegate?.didLoginSuccessfully()*/
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "showPopup") as! PopupVC
                self.present(vc, animated: true, completion: nil)
            }))
            
            self.present(alertController, animated: true, completion: nil)
            
            
            

        }
    }
    
    func loginAction() {
        self.dismiss(animated: false, completion: nil)
    }

    //dismiss keyboard when pressing return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
