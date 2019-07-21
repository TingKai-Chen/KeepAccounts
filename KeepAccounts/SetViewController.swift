import UIKit

class SetViewController: UIViewController {

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(rgb:0xD4FFD4)

    }

    @IBAction func location(_ sender: Any) {
        
        let alert = UIAlertController(title: "打開定位", message:"確定是否打開GoogleMap", preferredStyle: .alert)
        
        let action_OK = UIAlertAction(title: "確定", style: .default) { (action) in
            
            let alert = UIAlertController(title: "成功", message:"您已經成功打開GoogleMap", preferredStyle: .alert)
            
            let action_OK = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                
                self.dismiss(animated: true, completion: nil)
                
            })
            
            alert.addAction(action_OK)
            
            self.present(alert,animated: true,completion: nil)
            
        }
        
        let action_Cancel = UIAlertAction(title: "關閉", style: .cancel, handler: nil)
        
        alert.addAction(action_OK)
        
        alert.addAction(action_Cancel)
        
        self.present(alert,animated: true,completion: nil)
        
    }
    
}
