import UIKit

protocol UIFormViewControllerDeletage : class{
    
    func upDateCalendar (datePicker:UIDatePicker)

    func upDateData (data : Data)
    
}

class FormViewController: UIViewController {

    var n = 1
    
    var c = -1
    
    let allData = Data()
  
    var date : Date?
    
    var startDate : Date?
    
    let dateformatter = DateFormatter()

    weak var delegate : UIFormViewControllerDeletage?
    
    @IBOutlet weak var imageBtn: UIButton!
    
    @IBOutlet weak var priceTxt: UITextField!
    
    @IBOutlet weak var datePickerTxt: UITextField!
    
    @IBOutlet weak var projectTxt: UITextField!
    
    @IBOutlet weak var incomeExpendPickerTxt: UITextField!
    
    @IBOutlet weak var locationTxt: UITextField!
    
    @IBOutlet weak var roundTxt: UITextView!
    
    var incomeExpenseData = ["支出","收入"]
    
    var incomeExpenseDataPicker = UIPickerView()
    
    var dateDataPicker = UIDatePicker()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.incomeExpenseDataPicker.delegate = self
        
        self.incomeExpenseDataPicker.dataSource = self
        
        self.priceTxt.keyboardType = UIKeyboardType.decimalPad
        
        self.datePickerTxt.placeholder = "請選擇日期"
        
        self.incomeExpendPickerTxt.placeholder = "請選擇收支"
        
        self.projectTxt.placeholder = "請輸入文字"
        
        self.priceTxt.placeholder = "請輸入價格"
        
        self.datePickerTxt.borderStyle = .roundedRect
        
        self.incomeExpendPickerTxt.borderStyle = .roundedRect
        
        self.projectTxt.borderStyle = .roundedRect
        
        self.priceTxt.borderStyle = .roundedRect
        
        self.dateDataPicker.date = self.date!
        
        self.dateDataPicker.datePickerMode = .date
        
        self.dateDataPicker.locale = Locale(identifier: "zh_TW")
        
        self.dateDataPicker.minimumDate = self.startDate
        
        self.dateDataPicker.maximumDate = Date()
        
        self.datePickerTxt.inputView = self.dateDataPicker

        self.dateformatter.dateFormat = "yyyy年MM月dd日"
        
        self.datePickerTxt.text = dateformatter.string(from: self.date!)
        
        self.incomeExpendPickerTxt.inputView = self.incomeExpenseDataPicker
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        
        view.addGestureRecognizer(tap)
        
        let incomeExpendToolBar = UIToolbar()
        
        incomeExpendToolBar.barStyle = .default
        
        incomeExpendToolBar.sizeToFit()
        
        let incomeExpendFlexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let incomeExpendToolBarBtnDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.dissPicker))
        
        incomeExpendToolBar.items = [incomeExpendFlexSpace , incomeExpendToolBarBtnDone]
        
        self.incomeExpendPickerTxt.inputAccessoryView = incomeExpendToolBar
        
        let dateToolBar = UIToolbar()
        
        dateToolBar.barStyle = .default
        
        dateToolBar.sizeToFit()
        
        let dateFlexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let dateToolBarBtnDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.dissPicker))
        
        dateToolBar.items = [dateFlexSpace , dateToolBarBtnDone]
        
        self.datePickerTxt.inputAccessoryView = dateToolBar
        
        self.dateDataPicker.addTarget(self, action: #selector(FormViewController.datePickerValue(datePicker:)), for: .valueChanged)
        
        self.incomeExpendPickerTxt.addTarget(self, action: #selector(FormViewController.disPlayPickerValue), for: .touchDown)
        
        self.locationTxt.addTarget(self, action: #selector(FormViewController.goToMap), for: .touchDown)
        
        self.imageBtn.setImage(UIImage(named: "camera"), for: .normal)
        
        self.imageBtn.layer.masksToBounds = true
        
        self.imageBtn.layer.cornerRadius = 10
        
        self.imageBtn.layer.borderWidth = 2

        self.imageBtn.layer.borderColor = UIColor.red.cgColor
        
    }
    
    @objc func goToMap() {

        self.performSegue(withIdentifier: "MapSegue", sender: nil)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "MapSegue" {
            
            let mapVC = segue.destination as! MapViewController
            
            mapVC.delegate = self
            
        }
        
    }
    
    @objc func dissPicker () {
        
        self.view.endEditing(true)
        
    }
    
    @objc func closeKeyboard() {
        
        self.view.endEditing(true)
        
    }
    
    
    
    @objc func datePickerValue (datePicker: UIDatePicker) {
        
        self.dateformatter.dateFormat = "yyyy年MM月dd日"
        
        self.datePickerTxt.text = dateformatter.string(from: self.dateDataPicker.date)
        
        self.delegate?.upDateCalendar(datePicker: self.dateDataPicker)
        
    }
    
    @objc func disPlayPickerValue() {
        
        let selectedIndex = self.incomeExpenseDataPicker.selectedRow(inComponent: 0)
        
        self.incomeExpendPickerTxt.text = self.incomeExpenseData[selectedIndex]
        
    }
    
    @IBAction func determineBtn(_ sender: Any) {
        
        if self.datePickerTxt.text == "" || self.projectTxt.text == "" || self.incomeExpendPickerTxt.text == "" || self.priceTxt.text == "" {
            
            let alert = UIAlertController(title: "請輸入完整資料", message: nil, preferredStyle: .alert)
            
            let action_OK = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alert.addAction(action_OK)
            
            present(alert,animated: true,completion: nil)
            
        }
        
        else {
            
            self.allData.project = self.projectTxt.text!
                
            if self.incomeExpendPickerTxt.text == "支出" {
                
                let intPrice = Int(self.priceTxt.text!)! * self.c
                
                self.allData.price = String(intPrice)
                
            }
            
            else {
                
                let intPrice = Int(self.priceTxt.text!)! * self.n
                
                self.allData.price = String(intPrice)
                
            }
            
            self.allData.incomeExpend = self.incomeExpendPickerTxt.text!
            
            self.allData.address = self.locationTxt.text!
            
            self.allData.round = self.roundTxt.text
            
            self.allData.image = self.imageBtn.image(for: .normal)!
            
            self.delegate?.upDateData(data: self.allData)
            
            self.navigationController?.popViewController(animated: true)
            
        }
        
    }
    
    @IBAction func camera(_ sender: Any) {
        
        let imagePicker = UIImagePickerController()
        
        imagePicker.sourceType = .camera
        
        present(imagePicker,animated: true,completion: nil)
        
        imagePicker.delegate = self
        
    }
    
}

extension FormViewController : UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        self.incomeExpendPickerTxt.text = self.incomeExpenseData[row]
        
    }
    
}

extension FormViewController : UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return self.incomeExpenseData.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return self.incomeExpenseData[row]
        
    }
    
}

extension FormViewController : UIMapViewControllerDelegate {
    
    func upDateMapTxt(textField: UITextField) {
        
        self.locationTxt.text = textField.text
        
    }
    
}

extension FormViewController : UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            self.imageBtn.setImage(image, for: .normal)
            
        }
        
        dismiss(animated: true, completion:nil)
        
    }

}
