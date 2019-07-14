import UIKit

import Firebase

import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet var emailTxtField: UITextField!
    
    @IBOutlet var passwordTxtField: UITextField!
    
    @IBOutlet var loginBtn: UIButton!
    
    var homeView: ViewController?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.setLayout()
        
        self.emailTxtField.delegate = self
        
        self.passwordTxtField.delegate = self
        
        self.layoutLoginBtn()
        
        self.navigationItem.title = "登入"

    }
    
    private func setLayout() {
        
        self.emailTxtField.placeholder = "Email"
        
        self.passwordTxtField.placeholder = "Password"
        
        self.passwordTxtField.isSecureTextEntry = true
        
    }
    
    @IBAction func login(_ sender: Any) {
        
        if self.emailTxtField.text == "" || self.passwordTxtField.text == "" {
            
            let alertController = UIAlertController(title: "資料不完全", message: "請輸入正確的Email帳號及密碼", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            
            Auth.auth().signIn(withEmail: self.emailTxtField.text!, password: self.passwordTxtField.text!) { (user, error) in
                
                if error == nil {
                    
                    let user = Auth.auth().currentUser
                    
                    if let user = user {
                       
                        let uid = user.uid
                        
                        let email = user.email
                        
                        let photoURL = user.photoURL
                        
                         print("uid= \(uid) ;email=\(email) ; photoURL= \(photoURL)")
                        
                    }
                    
                    let alertController = UIAlertController(title: "登入", message: "您已經成功登入", preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        
                        let leftBarButton = UIBarButtonItem()
                        
                        self.homeView?.navigationItem.leftBarButtonItem = leftBarButton
                        
                        self.homeView?.signOutLayout()
                        
                        self.navigationController?.popViewController(animated: true)
                        
                    })
                    
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                    
                }
                    
                else {
                    
                    // 提示用戶從 firebase 返回了一個錯誤。
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
                
            }
            
        }
        
    }
    
    private func layoutLoginBtn() {
        
        self.loginBtn.clipsToBounds = true
        
        self.loginBtn.layer.cornerRadius = self.loginBtn.frame.height/2

    }
 
}

extension LoginViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    
}
