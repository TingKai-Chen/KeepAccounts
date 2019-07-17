import UIKit

import Firebase

import FirebaseAuth

import FirebaseDatabase

class SignUpViewController: UIViewController {
    
     lazy var ref = Database.database().reference()
    
    @IBOutlet weak var emailTxtField: UITextField!
    
    @IBOutlet weak var passwordTxtField: UITextField!
    
    @IBOutlet var nameTxtField: UITextField!
    
    @IBOutlet var addressTxtField: UITextField!
    
    @IBOutlet var numberTxtField: UITextField!
    
    @IBOutlet var doneBtn: UIButton!
    
    @IBOutlet var cancelBtn: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.emailTxtField.delegate = self
        
        self.passwordTxtField.delegate = self
        
        self.nameTxtField.delegate = self
        
        self.addressTxtField.delegate = self
        
        self.numberTxtField.delegate = self
        
        self.setLayout()
        
        self.layoutBtn()

    }
    
    private func layoutBtn () {
        
        self.doneBtn.clipsToBounds = true
        
        self.doneBtn.layer.cornerRadius = self.doneBtn.frame.height/2
        
        self.cancelBtn.clipsToBounds = true
        
        self.cancelBtn.layer.cornerRadius = self.cancelBtn.frame.height/2
       
    }
    
    private func setLayout() {
        
        self.emailTxtField.placeholder = "請輸入信箱"
        
        self.passwordTxtField.placeholder = "請輸入密碼"
        
        self.nameTxtField.placeholder = "請輸入姓名"
        
        self.addressTxtField.placeholder = "請輸入地址"
        
        self.numberTxtField.placeholder = "請輸入手機號碼"
        
        self.passwordTxtField.isSecureTextEntry = true
        
        
    }
    
    @IBAction func createAccount(_ sender: Any) {
        
        let username = self.nameTxtField.text
        
        let password = self.passwordTxtField.text
        
        let email = self.emailTxtField.text
        
        let phone = self.numberTxtField.text
        
        let address = self.addressTxtField.text
        
        if self.emailTxtField.text == "" || self.passwordTxtField.text == "" || self.nameTxtField.text == "" || self.addressTxtField.text == "" || self.numberTxtField.text == "" {
            let alertController = UIAlertController(title: "資料不完整", message: "請輸入表格上完整的資料", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        }
        
        else {
            
            Auth.auth().createUser(withEmail: self.emailTxtField.text!, password: self.passwordTxtField.text!) { (user, error) in
                
                if error == nil {
                    
                    print("您已經成功註冊")
                    
                    if let user = Auth.auth().currentUser {
                        
                        self.ref.child("User/\(user.uid)/UserName").setValue(username)
                        
                        self.ref.child("User/\(user.uid)/Password").setValue(password)
                        
                        self.ref.child("User/\(user.uid)/Email").setValue(email)
                        
                        self.ref.child("User/\(user.uid)/Phone").setValue(address)
                        
                        self.ref.child("User/\(user.uid)/Phone").setValue(phone)
                        
                    }
                    
                    let alertController = UIAlertController(title: "Success", message: "您已經成功註冊", preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        
                        self.dismiss(animated: true, completion: nil)

                    })
                    
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                    
                }
                
                else {
                    
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                    
                }
                
            }
            
        }
        
    }
    
    @IBAction func cancel(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
}

extension SignUpViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    
}

