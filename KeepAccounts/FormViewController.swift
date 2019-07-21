import UIKit

import CoreData

import FirebaseDatabase

protocol UIFormViewControllerDeletage : class{
    
    func upDateCalendar (datePicker:UIDatePicker)

    func upDateData ()
    
}

class FormViewController: UIViewController {
    
    @IBOutlet var button0: UIButton!
    
    @IBOutlet var button1: UIButton!
    
    @IBOutlet var button2: UIButton!
    
    @IBOutlet var button3: UIButton!
    
    @IBOutlet var button4: UIButton!
    
    @IBOutlet var button5: UIButton!
    
    @IBOutlet var button6: UIButton!

    @IBOutlet var button7: UIButton!
    
    @IBOutlet var button8: UIButton!
    
    @IBOutlet var button9: UIButton!
    
    @IBOutlet var buttonPeriod: UIButton!
    
    @IBOutlet var buttonPlusMinus: UIButton!
    
    @IBOutlet var buttonEqual: UIButton!
    
    @IBOutlet var buttonAddition: UIButton!
    
    @IBOutlet var buttonSubstraction: UIButton!
    
    @IBOutlet var buttonMultiplication: UIButton!
    
    @IBOutlet var buttonDivision: UIButton!
    
    @IBOutlet var buttonAllCancel: UIButton!
    
    @IBOutlet var calculatorView: UIView!
    
    var valueA: Int = 0
    
    var valueB: Int = 0
    
    var currentOperator: String = ""
    
    var refreshTextField: Bool = true
    
    let imagePicker = UIImagePickerController()
    
    var n = 1
    
    var c = -1
    
    var homeView: ViewController?
    
    var startDate: Date?
    
    var currentDate: Date!
    
    var allData : MyData?
    
    var dateformatter: DateFormatter {
    
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy年MM月dd日"
        
        return formatter
        
    }

    weak var delegate : UIFormViewControllerDeletage?
    
    @IBOutlet weak var imageBtn: UIButton!
    
    @IBOutlet weak var priceTxt: UITextField!
    
    @IBOutlet weak var datePickerTxt: UITextField!
    
    @IBOutlet var categoryPickerTxt: UITextField!
    
    @IBOutlet weak var projectTxt: UITextField!
    
    @IBOutlet weak var incomeExpendPickerTxt: UITextField!
    
    @IBOutlet weak var locationTxt: UITextField!
    
    @IBOutlet weak var roundTxt: UITextView!
    
    @IBOutlet var dete: UIButton!
    
    @IBOutlet var determineBtn: UIButton!
    
    @IBOutlet var cancelBtn: UIButton!
    
    @IBOutlet weak var textViewHistory: UITextView!
    
    @IBOutlet var subView: UIView!
    
    var categoryExpense = ["飲食","交通","通訊","服飾","居住","娛樂","日常","醫療","教育","保險","社交","健身美容","孝順養育","其他"]
    
    var categoryIncome = ["工資","獎金","外快","報銷","投資","其他"]
    
    var categoryDataPicker = UIPickerView()
    
    var incomeExpenseData = ["支出","收入"]
    
    var incomeExpenseDataPicker = UIPickerView()
    
    var datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        self.incomeExpenseDataPicker.delegate = self
        
        self.incomeExpenseDataPicker.dataSource = self
        
        self.categoryDataPicker.delegate = self
        
        self.categoryDataPicker.dataSource = self
        
        self.setLayout()
        
        self.setGesture()

        self.setIncomeExpendPicker()
        
        self.setDatePickerTextField()
        
        self.initView()
        
        self.layoutBtn()
        
        self.setCategoryPicker()
        
        self.navigationItem.title = "開始記帳"
        
        self.view.backgroundColor = UIColor(rgb:0xD4FFD4)
        
        self.setPriceInputView()
        
        self.setCalculatorBtnLayout()
        
        self.setMapVC()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        
        self.subView.backgroundColor = UIColor(rgb: 0xC9FFFF)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        self.locationTxt.addTarget(self, action: #selector(FormViewController.goToMap), for: .touchDown)
        
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
    
    @objc func disPlayincomeExpendPickerValue() {
        
        let selectedIndex = self.incomeExpenseDataPicker.selectedRow(inComponent: 0)
        
        if selectedIndex == 0 {
            
            self.categoryPickerTxt.text = categoryExpense[0]
            
        }
        
        else {
            
            self.categoryPickerTxt.text = categoryIncome[0]
            
        }
        
        self.incomeExpendPickerTxt.text = self.incomeExpenseData[selectedIndex]

    }
    
    @objc func disPlayCategoryPickerValue() {
        
        let selectedIndex = self.categoryDataPicker.selectedRow(inComponent: 0)
        
        if self.incomeExpendPickerTxt.text == self.incomeExpenseData[0] {
            
            self.categoryPickerTxt.text = self.categoryExpense[selectedIndex]
            
        }
        
        else if self.incomeExpendPickerTxt.text == self.incomeExpenseData[1] {
            
            self.categoryPickerTxt.text = self.categoryIncome[selectedIndex]
            
        }
        
    }
    
    private func setMapVC () {
        
        let alert = UIAlertController(title: "開啟定位", message: "請前往設定開啟定位功能", preferredStyle: .alert)
        
        let action_OK = UIAlertAction(title: "前往", style: .default) { (UIAlertAction) in
            
            self.performSegue(withIdentifier: "isOpenMap", sender: nil)
            
        }
        
        let action_Cancel = UIAlertAction(title:"取消", style:.cancel) { (action) in
            
            self.locationTxt.isEnabled = false
            
        }
        
        alert.addAction(action_OK)
        
        alert.addAction(action_Cancel)
        
        self.present(alert,animated: true,completion: nil)
        
    }
    
    
    @objc func goToMap() {
        
        self.performSegue(withIdentifier: "MapSegue", sender: nil)
        
    }
    
    @IBAction func determineBtn(_ sender: Any) {
        
        if self.datePickerTxt.text == "" || self.projectTxt.text == "" || self.incomeExpendPickerTxt.text == "" || self.priceTxt.text == "" || self.categoryPickerTxt.text == "" {
            
            let alert = UIAlertController(title: "請輸入完整資料", message: nil, preferredStyle: .alert)
            
            let action_OK = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alert.addAction(action_OK)
            
            present(alert,animated: true,completion: nil)
            
            return
            
        }
        
        self.saveToCoreData()
        
        self.delegate?.upDateData()
        
        self.homeView?.calendarView.reloadData()

        self.navigationController?.popViewController(animated: true)
        
    }
    
   
    
    @IBAction func camera(_ sender: Any) {
        
        self.imagePicker.delegate = self
        
        self.imagePicker.sourceType = .camera
        
        self.present(self.imagePicker, animated: true, completion: nil)
        
    }
    
//    private func createGradientLayer() {
//
//        let gradientLayer = CAGradientLayer()
//
//        gradientLayer.frame = self.view.bounds
//
//        gradientLayer.colors = [UIColor(rgb:0xfad0c4).cgColor, UIColor(rgb:0xffd1ff).cgColor]
//
//        self.view.layer.addSublayer(gradientLayer)
//
//        self.view.layer.insertSublayer(gradientLayer, at: 0)
//
//    }
    
    private func setLayout() {
        
        self.priceTxt.keyboardType = UIKeyboardType.decimalPad
        
        self.datePickerTxt.placeholder = "請選擇日期"
        
        self.incomeExpendPickerTxt.placeholder = "請選擇收支"
        
        self.projectTxt.placeholder = "請輸入文字"
        
        self.priceTxt.placeholder = "請輸入價格"
        
        self.categoryPickerTxt.placeholder = "請選擇分類"
        
        self.datePickerTxt.borderStyle = .roundedRect
        
        self.incomeExpendPickerTxt.borderStyle = .roundedRect
        
        self.projectTxt.borderStyle = .roundedRect
        
        self.priceTxt.borderStyle = .roundedRect
        
        self.datePickerTxt.text = self.dateformatter.string(from: currentDate)
        
        self.setImageBtn()
        
    }
    
    private func settingDatePicker() {
        
        self.datePicker.datePickerMode = .date
        
        self.datePicker.locale = Locale(identifier: "zh_TW")
        
        self.datePicker.minimumDate = self.startDate
        
        self.datePicker.maximumDate = Date()
        
        self.datePicker.date = currentDate
        
    }
    
    private func setGesture() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        
        view.addGestureRecognizer(tap)
        
    }
    
    private func setPriceInputView() {
        
        let priceToolBar = UIToolbar()
        
        priceToolBar.barStyle = .default
        
        priceToolBar.sizeToFit()
        
        let priceFlexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let priceToolBarBtnDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.dissPicker))
        
        priceToolBar.items = [priceFlexSpace , priceToolBarBtnDone]
        
        self.priceTxt.inputView = self.calculatorView
        
        self.priceTxt.inputAccessoryView = priceToolBar
        
    }
    
    private func setCalculatorBtnLayout() {
        
        self.button0.layer.borderWidth = 1
        
        self.button0.layer.borderColor = UIColor.white.cgColor
        
        self.button1.layer.borderWidth = 1
        
        self.button1.layer.borderColor = UIColor.white.cgColor
        
        self.button2.layer.borderWidth = 1
        
        self.button2.layer.borderColor = UIColor.white.cgColor
        
        self.button3.layer.borderWidth = 1
        
        self.button3.layer.borderColor = UIColor.white.cgColor
        
        self.button4.layer.borderWidth = 1
        
        self.button4.layer.borderColor = UIColor.white.cgColor
        
        self.button5.layer.borderWidth = 1
        
        self.button5.layer.borderColor = UIColor.white.cgColor
        
        self.button6.layer.borderWidth = 1
        
        self.button6.layer.borderColor = UIColor.white.cgColor
        
        self.button7.layer.borderWidth = 1
        
        self.button7.layer.borderColor = UIColor.white.cgColor
        
        self.button8.layer.borderWidth = 1
        
        self.button8.layer.borderColor = UIColor.white.cgColor
        
        self.button9.layer.borderWidth = 1
        
        self.button9.layer.borderColor = UIColor.white.cgColor
        
        self.buttonPeriod.layer.borderWidth = 1
        
        self.buttonPeriod.layer.borderColor = UIColor.white.cgColor
        
        self.buttonPlusMinus.layer.borderWidth = 1
        
        self.buttonPlusMinus.layer.borderColor = UIColor.white.cgColor
        
        self.buttonEqual.layer.borderWidth = 1
        
        self.buttonEqual.layer.borderColor = UIColor.white.cgColor
        
        self.buttonAddition.layer.borderWidth = 1
        
        self.buttonAddition.layer.borderColor = UIColor.white.cgColor
        
        self.buttonSubstraction.layer.borderWidth = 1
        
        self.buttonSubstraction.layer.borderColor = UIColor.white.cgColor
        
        self.buttonMultiplication.layer.borderWidth = 1
        
        self.buttonMultiplication.layer.borderColor = UIColor.white.cgColor
        
        self.buttonDivision.layer.borderWidth = 1
        
        self.buttonDivision.layer.borderColor = UIColor.white.cgColor
        
        self.buttonAllCancel.layer.borderWidth = 1
        
        self.buttonAllCancel.layer.borderColor = UIColor.white.cgColor
        
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
        
        self.incomeExpendPickerTxt.addTarget(self, action: #selector(FormViewController.disPlayincomeExpendPickerValue), for: .touchDown)
        
    }
    
    private func setCategoryPicker() {
        
        let catgorytoolBar = UIToolbar()
        
        catgorytoolBar.barStyle = .default
        
        catgorytoolBar.sizeToFit()
        
        let categoryFlexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let categoryToolBarBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.dissPicker))
        
        catgorytoolBar.items = [categoryFlexSpace,categoryToolBarBtn]
        
        self.categoryPickerTxt.inputView = self.categoryDataPicker
        
        self.categoryPickerTxt.inputAccessoryView = catgorytoolBar
        
        self.categoryPickerTxt.addTarget(self, action: #selector(FormViewController.disPlayCategoryPickerValue), for: .touchDown)
        
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
        
        self.datePickerTxt.text = self.dateformatter.string(from: currentDate)
        
        guard let allData = self.allData else { return }
        
        self.projectTxt.text = allData.projectName
        
        if allData.incomeExpend == self.incomeExpenseData[0] {

            if let intPrice = Int(allData.price!) {

                self.priceTxt.text = "\(intPrice * -1)"

            }

        }

        else {

            self.priceTxt.text = allData.price

        }

        self.incomeExpendPickerTxt.text = allData.incomeExpend
        
        self.categoryPickerTxt.text = allData.category

        if allData.image == UIImage(named: "account") || allData.image == nil {

            self.imageBtn.setImage(UIImage(named: "camera"), for: .normal)

        }

        else {

            self.imageBtn.setImage(allData.image, for: .normal)

        }

        if allData.address == "" {

            self.locationTxt.text = ""

        }
            
        else {
            
            self.locationTxt.text = allData.address
            
        }


        if allData.round == "" {

            self.roundTxt.text = ""

        }

        else {

            self.roundTxt.text = allData.round

        }

    }
    
    private func layoutBtn() {
        
        self.cancelBtn.clipsToBounds = true
        
        self.cancelBtn.layer.cornerRadius = self.cancelBtn.frame.height/2
        
        self.determineBtn.clipsToBounds = true
        
        self.determineBtn.layer.cornerRadius = self.determineBtn.frame.height/2
        
    }
    
    func saveToCoreData() {
        
        self.allData!.projectName = self.projectTxt.text!
        
        if self.incomeExpendPickerTxt.text == self.incomeExpenseData[0] {
            
            let intPrice = Int(self.priceTxt.text!)! * self.c
            
            self.allData!.price = String(intPrice)
            
        }
            
        else {
            
            let intPrice = Int(self.priceTxt.text!)! * self.n
            
            self.allData!.price = String(intPrice)
            
        }
        
        self.allData!.incomeExpend = self.incomeExpendPickerTxt.text!
        
        self.allData!.category = self.categoryPickerTxt.text!
        
        self.allData!.address = self.locationTxt.text
        
        self.allData!.round = self.roundTxt.text
        
        CoreDataHelper.shared.saveContext()
        
    }
    
    @IBAction func allCancel(_ sender: UIButton) {
        
       
        self.valueA = 0
        
        self.valueB = 0
        
        self.currentOperator = ""
        
        self.refreshTextField = true
        
        // update text field
        self.priceTxt.text = "0"
        
    }
    
    
    @IBAction func numberPress(_ sender: UIButton) {
        // find text to be added
        var value = sender.currentTitle!
        // get current text
        var currentText = ""
        
        // value shourld be refreshed?
        if self.priceTxt.text != "0" && (!self.refreshTextField  || value == "±") {
            currentText = self.priceTxt.text!
        }
        
        // zero
        if currentText == "0" && value == "0" {
            value = ""
        }
        
        // period
        if value == "." {
            if currentText == "" {
                value = "0."
            } else if currentText.range(of: ".") != nil {
                value = ""
            }
        }
        
        // plus/minus
        if value == "±" {
            value = ""
            if currentText != "" {
                if currentText.hasPrefix("-") {
                    let start = currentText.startIndex
                    let end = currentText.index(after: start)
                    currentText = currentText.replacingOccurrences(of: "-", with: "", range: start..<end)
                } else {
                    currentText = "-\(currentText)"
                }
            }
        }
        
        // update text field
        self.refreshTextField = false
        
        self.priceTxt.text = "\(currentText)\(value)"
        
    }
    
    
    @IBAction func operatorPress(_ sender: UIButton) {
        
        // ignore if text field is empty
        if self.priceTxt.text != "" {
            // get new operator
            let newOperator = sender.titleLabel?.text!
            // refresh text field
            self.refreshTextField = true
            
            if self.currentOperator == "" && newOperator != "=" {
                // copy current value
                self.valueA = Int(self.priceTxt.text!)!
                
                // update operator
                self.currentOperator = newOperator!
            } else {
                // copy current value
                self.valueB = Int(self.priceTxt.text!)!
                
                // perform operation
                var result: Int = 0
                switch self.currentOperator {
                case "+":
                    result = self.valueA + valueB
                case "-":
                    result = valueA - self.valueB
                case "×":
                    result = self.valueA * self.valueB
                case "÷":
                    result = self.valueA / self.valueB
                default:
                    result = self.valueB
                }
                
                if currentOperator != "" {
                    // construct history entry
                    let historyEntry: String = "\(valueA) \(currentOperator) \(valueB) = \(result)\n"
                    // update history
                    self.textViewHistory.text! += historyEntry
                }
                
                // update operator & values
                self.currentOperator = ""
                self.valueA = 0
                self.valueB = 0
                
                if newOperator != "=" {
                    self.valueA = result
                    self.currentOperator = newOperator!
                }
                
                // update text field
                self.priceTxt.text = String(result)
            }
        }
        
    }
    
    
    deinit {
        
        CoreDataHelper.shared.resetContext()
        
        self.homeView?.queryFromCoreData()
        
    }
    
}

extension FormViewController : UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == self.incomeExpenseDataPicker {
            
            self.incomeExpendPickerTxt.text = self.incomeExpenseData[row]
            
        }
        
        else if pickerView == self.categoryDataPicker && self.incomeExpendPickerTxt.text! == incomeExpenseData[0] {
            
            self.categoryPickerTxt.text = self.categoryExpense[row]
            
        }
        
        else if pickerView == self.categoryDataPicker && self.incomeExpendPickerTxt.text! == incomeExpenseData[1] {
            
            self.categoryPickerTxt.text = self.categoryIncome[row]
            
        }
        
    }
    
}

extension FormViewController : UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView == self.incomeExpenseDataPicker {
            
             return self.incomeExpenseData.count
            
        }
        else if pickerView == self.categoryDataPicker && self.incomeExpendPickerTxt.text! == incomeExpenseData[0] {
            
            return self.categoryExpense.count
            
        }
        
        else if pickerView == self.categoryDataPicker && self.incomeExpendPickerTxt.text! == incomeExpenseData[1] {
            
            return self.categoryIncome.count
            
        }
        
        return 1
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == self.incomeExpenseDataPicker {
            
            return self.incomeExpenseData[row]
            
        }
            
        else if pickerView == self.categoryDataPicker && self.incomeExpendPickerTxt.text! == incomeExpenseData[0] {
            
            return self.categoryExpense[row]
            
        }
            
        else if pickerView == self.categoryDataPicker && self.incomeExpendPickerTxt.text! == incomeExpenseData[1] {
            
            return self.categoryIncome[row]
            
        }
        
        return ""
        
    }
    
}

extension FormViewController : UIMapViewControllerDelegate {
    
    func upDateMapTxt(textField: UITextField) {
        
        self.locationTxt.text = textField.text
        
    }
    
}

extension FormViewController : UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage,
            let scaledImage = image.scaled(with: 0.05) {
            
            self.imageBtn.setImage(scaledImage, for: .normal)
            
            self.allData?.image = scaledImage
            
        }
        
        picker.dismiss(animated: true, completion: nil)
        
    }

}

extension UIImage {
    
    func scaled(with scale: CGFloat) -> UIImage? {
        // size has to be integer, otherwise it could get white lines
        let size = CGSize(width: floor(self.size.width * scale), height: floor(self.size.height * scale))
        UIGraphicsBeginImageContext(size)
        draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

