import UIKit

protocol UIFormViewControllerDeletage : class{
    
    func upDateCalendar (datePicker:UIDatePicker)

    func upDateData (data : Data)
    
}

class FormViewController: UIViewController {

    var n = 1
    
    var c = -1
    
    var homeView: ViewController?
    
    var allData: Data!
    
    var startDate: Date?
    
    var dateformatter: DateFormatter {
    
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy年MM月dd日"
        
        return formatter
        
    }

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
    
    var datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        self.incomeExpenseDataPicker.delegate = self
        
        self.incomeExpenseDataPicker.dataSource = self
        
        self.setLayout()
        
        self.setGesture()

        self.setIncomeExpendPicker()
        
        self.setDatePickerTextField()
 
        self.locationTxt.addTarget(self, action: #selector(FormViewController.goToMap), for: .touchDown)
        
        self.initView()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.createGradientLayer()
        
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
        
        self.datePickerTxt.text = self.dateformatter.string(from: self.datePicker.date)
        
        self.delegate?.upDateCalendar(datePicker: self.datePicker)
        
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
            
            if self.allData.price != nil {
                
                self.updateRecord()
                
            }
            else {
                
                self.addNewRecord()

            }
            
        }
        
    }
    
    @IBAction func camera(_ sender: Any) {
        
        let imagePicker = UIImagePickerController()
        
        imagePicker.sourceType = .camera
        
        present(imagePicker,animated: true,completion: nil)
        
        imagePicker.delegate = self
        
    }
    
    private func createGradientLayer() {
        
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = self.view.bounds
        
        gradientLayer.colors = [UIColor(rgb:0xfad0c4).cgColor, UIColor(rgb:0xffd1ff).cgColor]
        
        self.view.layer.addSublayer(gradientLayer)
        
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        
    }
    
    private func setLayout() {
        
        self.priceTxt.keyboardType = UIKeyboardType.decimalPad
        
        self.datePickerTxt.placeholder = "請選擇日期"
        
        self.incomeExpendPickerTxt.placeholder = "請選擇收支"
        
        self.projectTxt.placeholder = "請輸入文字"
        
        self.priceTxt.placeholder = "請輸入價格"
        
        self.datePickerTxt.borderStyle = .roundedRect
        
        self.incomeExpendPickerTxt.borderStyle = .roundedRect
        
        self.projectTxt.borderStyle = .roundedRect
        
        self.priceTxt.borderStyle = .roundedRect
        
        self.datePickerTxt.text = self.dateformatter.string(from: self.allData.date)
        
        self.setImageBtn()
        
    }
    
    private func settingDatePicker() {
        
        self.datePicker.datePickerMode = .date
        
        self.datePicker.locale = Locale(identifier: "zh_TW")
        
        self.datePicker.minimumDate = self.startDate
        
        self.datePicker.maximumDate = Date()
        
        self.datePicker.date = self.allData.date
        
    }
    
    private func setGesture() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        
        view.addGestureRecognizer(tap)
        
    }
    
    private func setIncomeExpendPicker() {
        
        let incomeExpendToolBar = UIToolbar()
        
        incomeExpendToolBar.barStyle = .default
        
        incomeExpendToolBar.sizeToFit()
        
        let incomeExpendFlexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let incomeExpendToolBarBtnDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.dissPicker))
        
        incomeExpendToolBar.items = [incomeExpendFlexSpace , incomeExpendToolBarBtnDone]
        
        self.incomeExpendPickerTxt.inputView = self.incomeExpenseDataPicker
        
        self.incomeExpendPickerTxt.inputAccessoryView = incomeExpendToolBar
        
        self.incomeExpendPickerTxt.addTarget(self, action: #selector(FormViewController.disPlayPickerValue), for: .touchDown)
        
    }
    
    private func setDatePickerTextField() {
        
        self.settingDatePicker()
        
        let dateToolBar = UIToolbar()
        
        dateToolBar.barStyle = .default
        
        dateToolBar.sizeToFit()
        
        let dateFlexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let dateToolBarBtnDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.dissPicker))
        
        dateToolBar.items = [dateFlexSpace , dateToolBarBtnDone]
        
        self.datePickerTxt.inputView = self.datePicker
        
        self.datePickerTxt.inputAccessoryView = dateToolBar
        
        self.datePicker.addTarget(self, action: #selector(FormViewController.datePickerValue(datePicker:)), for: .valueChanged)
        
    }
    
    private func setImageBtn() {
        
        self.imageBtn.setImage(UIImage(named: "camera"), for: .normal)
        
        self.imageBtn.layer.masksToBounds = true
        
        self.imageBtn.layer.cornerRadius = 10
        
        self.imageBtn.layer.borderWidth = 2
        
        self.imageBtn.layer.borderColor = UIColor.red.cgColor
        
    }
    
    private func initView() {
        
        self.datePickerTxt.text = self.dateformatter.string(from: self.allData.date)
        
        self.projectTxt.text = self.allData.projectName
        
        if self.allData.incomeExpend == self.incomeExpenseData[0] {

            if let intPrice = Int(self.allData.price!) {

                self.priceTxt.text = "\(intPrice * -1)"

            }

        }

        else {

            self.priceTxt.text = self.allData.price

        }

        self.incomeExpendPickerTxt.text = self.allData.incomeExpend

        if self.allData.image == UIImage(named: "account") || self.allData.image == nil {

            self.imageBtn.setImage(UIImage(named: "camera"), for: .normal)

        }

        else {

            self.imageBtn.setImage(self.allData.image, for: .normal)

        }

        if self.allData.address == "" {

            self.locationTxt.text = ""

        }
            
        else {
            
            self.locationTxt.text = self.allData.address
            
        }


        if self.allData.round == "" {

            self.roundTxt.text = ""

        }

        else {

            self.roundTxt.text = self.allData.round

        }

    }
    
    private func addNewRecord() {
        
        self.allData.projectName = self.projectTxt.text!
        
        if self.incomeExpendPickerTxt.text == self.incomeExpenseData[0] {
            
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
    
    private func updateRecord() {
        
        self.allData.projectName = self.projectTxt.text!
        
        if self.incomeExpendPickerTxt.text == self.incomeExpenseData[0] {
            
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
        
        self.homeView?.tableView.reloadData()
        
        self.homeView?.caculateSummary()
        
        self.navigationController?.popViewController(animated: true)
        
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
