import UIKit

import FirebaseAuth

class ResetPasswordViewController: UIViewController {

    @IBOutlet var emailTxtField: UITextField!

    @IBOutlet var doneBtn: UIButton!
    
    @IBOutlet var cancelBtn: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.setLayout()
        
        self.emailTxtField.delegate = self
        
        self.layoutBtn()
        
    }
    
    private func setLayout() {
        
        self.emailTxtField.placeholder = "請輸入E-mail"
        
    }
    
    @IBAction func resetPassword(_ sender: Any) {
        
        if self.emailTxtField.text == "" {
            
            let alertController = UIAlertController(title: "Error",message: "請輸入E-mail",preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        }
        
        else {
            
            Auth.auth().sendPasswordReset(withEmail: self.emailTxtField.text!, completion: { (error) in
                
                var title = ""
                
                var message = ""
                
                if error != nil {
                    
                    title = "Error!"
                    
                    message = (error?.localizedDescription)!
                    
                }
                    
                else {
                    
                    title = "Success!"
                    
                    message = "Password reset email sent."
                    
                    self.emailTxtField.text = ""
                    
                }
                
                let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
                    
                    self.dismiss(animated: true, completion: nil)
                    
                })
                
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
                
            })
        }
        
    }
    
    @IBAction func cancel(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    private func layoutBtn () {
        
        self.doneBtn.clipsToBounds = true
        
        self.doneBtn.layer.cornerRadius = self.doneBtn.frame.height/2
        
        self.cancelBtn.clipsToBounds = true
        
        self.cancelBtn.layer.cornerRadius = self.cancelBtn.frame.height/2
        
        
    }

}

extension ResetPasswordViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    
}
