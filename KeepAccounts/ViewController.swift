import UIKit

import JTAppleCalendar

import Firebase

import FirebaseAuth

class ViewController: UIViewController {
    
    @IBOutlet weak var totalPriceLab: UILabel!
    
    @IBOutlet weak var dateLab: UILabel!
    
    @IBOutlet var calendarView: JTAppleCalendarView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var startAccountBtn: UIButton!
    
    @IBOutlet weak var totalPriceNameLab: UILabel!
    
    @IBOutlet weak var toolBar: UIToolbar!
    
    var dataArray : [MyData] = [] {
        
        didSet {
            
            self.caculateSummary()
            
        }
        
    }
    
    var totalPrice = 0
    
    var date = Date()
    
    var startDate = Date()
    
    var endDate = Date()
    
    var formatter: DateFormatter {
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "dd-MMM-yyyy"
        
        return formatter
        
    }
    
    var leftBarButton = UIBarButtonItem()
    
    var rightBarButton = UIBarButtonItem()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.setPrortocol()
        
        self.setCalendarViewLayout()
        
        self.setAccountBtnLayout()

        self.setGradientLayerBtn()
        
        self.setTotalPriceNameLabLayout()
        
        self.setNavigationLayout()
        
        self.setToolBarLayout()
        
        self.totalPriceLab.text = String(self.totalPrice)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.createGradientLayer()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        if self.calendarView.selectedDates.count == 0 {
            
            self.calendarView.selectDates([self.endDate])
            
        }

    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        
        super.setEditing(editing, animated: true)
        
        self.tableView.setEditing(editing, animated: true)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Segue" {
            
            let FormVC = segue.destination as! FormViewController
            
            FormVC.currentDate = self.date
            
            FormVC.startDate = self.startDate
            
            FormVC.delegate = self
            
        }
            
        else if segue.identifier == "dataSegue" {
            
            let formVC = segue.destination as! FormViewController
            
            if let data = sender as? MyData {
                
                formVC.allData = data
                
                formVC.homeView = self
                
            }
            
        }
        
        else if segue.identifier == "LoginSegue" {
            
            let loginVC = segue.destination as! LoginViewController
            
            loginVC.homeView = self
            
        }
        
    }
    
    func configureCell(view: JTAppleCell?, cellState: CellState) {
        
        guard let cell = view as? DateCell  else { return }
        
        cell.dateLabel.text = cellState.text
        
        handleCellTextColor(cell: cell, cellState: cellState)
        
        handleCellSelected(cell: cell, cellState: cellState)
        
    }
    
    func handleCellTextColor(cell: DateCell, cellState: CellState) {
        
        if cellState.dateBelongsTo == .thisMonth {
            
            cell.dateLabel.textColor = UIColor.black
            
        }
        
        else {
            
            cell.dateLabel.textColor = UIColor.gray
            
        }
        
    }
    
    func handleCellSelected(cell: DateCell, cellState: CellState) {
        
        if cellState.isSelected {
            
            cell.selectedView.layer.cornerRadius = cell.selectedView.frame.height/2
            
            cell.selectedView.clipsToBounds = true
            
            cell.selectedView.isHidden = false
            
            cell.dateLabel.textColor = UIColor.white
            
            self.dataArray = []
            
            self.tableView.reloadData()
            
        }
        
        else {
            
            cell.selectedView.isHidden = true
            
        }
        
    }
    
    func caculateSummary() {
        
        let totalPrice = self.dataArray.compactMap({Int($0.price!)}).reduce(0, {$0 + $1})
        
        if totalPrice < 0 {
            
            self.totalPriceLab.textColor = UIColor.red
            
            self.totalPriceLab.text = String(totalPrice)
            
//            self.totalPriceLab.shadowColor = UIColor.gray
//
//            self.totalPriceLab.shadowOffset = CGSize(width: 1, height: 1)
//
        }
            
        else if totalPrice == 0 {
            
            self.totalPriceLab.textColor = UIColor(rgb: 0xc6a300)
            
            self.totalPriceLab.text = String(totalPrice)
//
//            self.totalPriceLab.shadowColor = UIColor.gray
//
//            self.totalPriceLab.shadowOffset = CGSize(width: 1, height: 1)
//
        }
            
        else {
            
            self.totalPriceLab.textColor = UIColor(rgb: 0x009100)
            
            self.totalPriceLab.text =  "+" + String(totalPrice)
            
//            self.totalPriceLab.shadowColor = UIColor.gray
//
//            self.totalPriceLab.shadowOffset = CGSize(width: 1, height: 1)
            
        }
        
    }
    
    private func createGradientLayer() {
        
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = self.view.bounds
        
        gradientLayer.colors = [UIColor(rgb:0xfdfcfb).cgColor, UIColor(rgb:0xe2d1c3).cgColor]
        
        self.view.layer.addSublayer(gradientLayer)
        
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        
    }
    
    private func setNavigationLayout() {
        
        let image = UIImage(named: "user")
        
        self.leftBarButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(self.setLogin))
        
        self.navigationItem.leftBarButtonItem = self.leftBarButton
       
        self.navigationController?.navigationBar.barTintColor = UIColor(rgb: 0xffffff)
        
        self.navigationController?.navigationBar.tintColor = .black

        let image2 = UIImage(named: "plus")
        
        self.rightBarButton = UIBarButtonItem(image: image2, style: .plain, target: self, action: #selector(self.rightBtn))
        
        self.navigationItem.rightBarButtonItem = self.rightBarButton
        
    }
    
    func signOutLayout() {
       
        let image = UIImage(named: "sign-out")
        
        self.leftBarButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(self.signOut))
        
        self.navigationItem.leftBarButtonItem = self.leftBarButton
        
    }
    
    private func setToolBarLayout() {
        
        let statisticButton = UIButton(type:.custom)

        statisticButton.imageView?.contentMode = .scaleAspectFit

        statisticButton.imageEdgeInsets = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)

        let statisticImage = UIImage(named: "pie-chart")
        
        statisticButton.setImage(statisticImage, for: .normal)
        
        let statisticBtnItem = UIBarButtonItem(customView: statisticButton)
        
        let statisticCurrWidth = statisticBtnItem.customView?.widthAnchor.constraint(equalToConstant: 24)

        statisticCurrWidth?.isActive = true

        let statisticCurrHeight = statisticBtnItem.customView?.heightAnchor.constraint(equalToConstant: 24)

        statisticCurrHeight?.isActive = true
        
    
        let detailButton = UIButton(type:.custom)
        
        detailButton.imageView?.contentMode = .scaleAspectFit
        
        detailButton.imageEdgeInsets = UIEdgeInsets(top: 40, left: 40, bottom: 40, right: 40)
        
        let detailImage = UIImage(named: "seo")
        
        detailButton.setImage(detailImage, for: .normal)
        
        let detailBtnItem = UIBarButtonItem(customView: detailButton)
        
        let detailCurrWidth = detailBtnItem.customView?.widthAnchor.constraint(equalToConstant: 24)
        
        detailCurrWidth?.isActive = true
        
        let detailCurrHeight = statisticBtnItem.customView?.heightAnchor.constraint(equalToConstant: 24)
        
        detailCurrHeight?.isActive = true
        
        
        let setButton = UIButton(type:.custom)
        
        setButton.imageView?.contentMode = .scaleAspectFit
        
        setButton.imageEdgeInsets = UIEdgeInsets(top: 33, left: 33, bottom: 33, right: 33)
        
        let setImage = UIImage(named: "settings")
        
        setButton.setImage(setImage, for: .normal)
        
        let setBtnItem = UIBarButtonItem(customView: setButton)
        
        let setCurrWidth = setBtnItem.customView?.widthAnchor.constraint(equalToConstant: 24)
        
        setCurrWidth?.isActive = true
        
        let setCurrHeight = setBtnItem.customView?.heightAnchor.constraint(equalToConstant: 24)
        
        setCurrHeight?.isActive = true
        
        var items = [UIBarButtonItem]()
        
        items.append(detailBtnItem)
        
        items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        
        items.append(statisticBtnItem)
        
        items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        
        items.append(setBtnItem)
        
        self.toolBar.items = items

    }
    
    private func setPrortocol() {
        
        self.tableView.delegate = self
        
        self.tableView.dataSource = self
        
        self.calendarView.calendarDelegate = self
        
        self.calendarView.calendarDataSource = self
        
    }
    
    private func setCalendarViewLayout() {
        
        self.calendarView.scrollDirection = .horizontal
        
        self.calendarView.scrollingMode = .stopAtEachCalendarFrame
        
        self.calendarView.showsHorizontalScrollIndicator = false
        
        self.calendarView.layer.borderWidth = 1
        
        self.calendarView.layer.borderColor = UIColor(rgb: 0xff0000).cgColor

        self.calendarView.layer.shadowColor = UIColor.darkGray.cgColor

        self.calendarView.layer.shadowOpacity = 0.8

        self.calendarView.layer.shadowOffset = CGSize(width: 5, height: 5)

    }
    
    private func setAccountBtnLayout() {
        
        self.startAccountBtn.setTitle("記一筆", for: .normal)
        
        self.startAccountBtn.clipsToBounds = true
        
        self.startAccountBtn.layer.cornerRadius = self.startAccountBtn.frame.height/2

    }
    
    private func setGradientLayerBtn() {
        
        let gradientLayerBtn = CAGradientLayer()
        
        gradientLayerBtn.startPoint = CGPoint(x: 0, y: 0.5)
        
        gradientLayerBtn.endPoint = CGPoint(x: 1, y: 0.5)
        
        gradientLayerBtn.frame = self.startAccountBtn.bounds
        
        gradientLayerBtn.colors = [UIColor(rgb:0xff0080).cgColor, UIColor(rgb:0xf75000).cgColor]
        
        self.startAccountBtn.layer.addSublayer(gradientLayerBtn)
        
    }
    
    private func setTotalPriceNameLabLayout() {
        
//        self.totalPriceNameLab.textColor = UIColor(rgb: 0x5b5b5b)
//
//        self.totalPriceNameLab.text = "每日收支總額 :"
//
//        self.totalPriceNameLab.font = UIFont.boldSystemFont(ofSize: 24)
//
//        self.totalPriceNameLab.sizeToFit()
    
        let label = UILabel()

        label.text = "每日總額:"

        label.font = UIFont.boldSystemFont(ofSize: 24)

        label.sizeToFit()

        let gradientLayerLab = CAGradientLayer()

        gradientLayerLab.frame = self.totalPriceNameLab.bounds

        gradientLayerLab.colors = [UIColor(rgb:0x00e3e3).cgColor, UIColor(rgb:0xff9224).cgColor]

        self.totalPriceNameLab.clipsToBounds = false

        self.totalPriceNameLab.layer.addSublayer(gradientLayerLab)

        self.totalPriceNameLab.mask = label
        
    }
    
    func upDateData(data: MyData) {
        
        self.dataArray.append(data)
        
        self.tableView.reloadData()
        
    }
    
    @objc func rightBtn() {
        
        self.performSegue(withIdentifier: "Segue", sender: nil)
        
    }
    
    @objc func setLogin() {
        
        performSegue(withIdentifier: "LoginSegue", sender: nil)
        
    }
    
    @objc func signOut() {
        
        let alertController = UIAlertController(title: "登出", message: "是否確定要登出", preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "登出", style: .default) { (action) in
            
            if Auth.auth().currentUser != nil {
                
                do {
                    
                    try Auth.auth().signOut()
                    
                }
                    
                catch let error as NSError {
                    
                    print(error.localizedDescription)
                    
                }
                
            }
            
            self.setNavigationLayout()
            
            self.performSegue(withIdentifier: "LoginSegue", sender: nil)
            
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        alertController.addAction(defaultAction)
        
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
}

extension ViewController: JTAppleCalendarViewDataSource {
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        
        self.startDate = self.formatter.date(from: "01-jan-1970")!
        
        self.endDate = Date()
        
        self.calendarView.scrollToDate(self.endDate, animateScroll: false)
        
        return ConfigurationParameters(startDate: self.startDate, endDate: self.endDate)
        
    }
    
}

extension ViewController: JTAppleCalendarViewDelegate {
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "dateCell", for: indexPath) as! DateCell
        
        configureCell(view: cell, cellState: cellState)
        
        return cell
        
    }
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        
        configureCell(view: cell, cellState: cellState)
        
    }
    
    func calendar(_ calendar: JTAppleCalendarView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTAppleCollectionReusableView {
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy年 MMM"
        
        formatter.locale = Locale(identifier: "zh_TW")
        
        let header = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: "DateHeader", for: indexPath) as! DateHeader
        
        header.monthTitle.text = formatter.string(from: range.start)
        
        return header
        
    }
    
    func calendarSizeForMonths(_ calendar: JTAppleCalendarView?) -> MonthSize? {
        
        return MonthSize(defaultSize: 50)
        
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        
        configureCell(view: cell, cellState: cellState)
        
        self.date = date
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy年 MM月 dd日"
        
        formatter.locale = Locale(identifier: "zh_TW")
        
        let myShadow = NSShadow()
        
        myShadow.shadowBlurRadius = 3
        
        myShadow.shadowOffset = CGSize(width: 2, height: 2)
        
        myShadow.shadowColor = UIColor.gray
        
        let myAttribute = [ NSAttributedString.Key.font: UIFont(name: "Chalkduster", size: 20.0)! , NSAttributedString.Key.shadow: myShadow ]
        
        let myAttrString = NSAttributedString(string: formatter.string(from: self.date), attributes: myAttribute)
       
        self.dateLab.attributedText = myAttrString
        
        self.dateLab.textColor = UIColor(rgb: 0xff0080)
        
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        
        configureCell(view: cell, cellState: cellState)
        
    }
    
}

extension ViewController : UIFormViewControllerDeletage {
    
    func upDateCalendar(datePicker: UIDatePicker) {
        
        self.date = datePicker.date
        
        self.calendarView.selectDates([self.date])
        
        self.calendarView.scrollToDate(self.date,animateScroll:false)
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy年MM月dd日"
        
        formatter.locale = Locale(identifier: "zh_TW")
        
        self.dateLab.text = formatter.string(from: self.date)
        
    }

}

extension ViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        let data = self.dataArray[indexPath.row]
        
        self.performSegue(withIdentifier: "dataSegue", sender: data)
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.backgroundColor = UIColor(rgb: 0xffffff)
        
    }
    
}

extension ViewController : UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return dataArray.count

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! Cell
        
        cell.projectLab.text = self.dataArray[indexPath.row].projectName
        
        if self.dataArray[indexPath.row].incomeExpend == "支出" {
            
            cell.priceLab.textColor = UIColor.red
            
            cell.priceLab.text = self.dataArray[indexPath.row].price! + "$ "
            
        }
        
        if self.dataArray[indexPath.row].incomeExpend == "收入" {
            
            cell.priceLab.textColor = UIColor(rgb: 0x009100)
                
            cell.priceLab.text = "+" + self.dataArray[indexPath.row].price! + "$ "
            
        }
        
        cell.addressLab.text = self.dataArray[indexPath.row].address
        
        cell.roundLab.text = self.dataArray[indexPath.row].round
        
        if self.dataArray[indexPath.row].image == UIImage(named: "camera") {
            
            self.dataArray[indexPath.row].image = UIImage(named: "account")!
            
            cell.photoImage.image = self.dataArray[indexPath.row].thumbnailImage()
            
        }
        
        else {
            
            cell.photoImage.image = self.dataArray[indexPath.row].thumbnailImage()
            
        }
        
        if self.dataArray[indexPath.row].address == "" {
            
            cell.addressLab.text = "無填寫此筆資料"
            
        }
        
        if self.dataArray[indexPath.row].round == "" {
            
            cell.roundLab.text = "無填寫此筆資料"
            
        }
        
        return cell

    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let deleteDataArray = self.dataArray.remove(at: indexPath.row)
            
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
        }
        
    }
    
}

extension UIColor {
    
    convenience init(red: Int, green: Int, blue: Int) {
        
        assert(red >= 0 && red <= 255, "Invalid red component")
        
        assert(green >= 0 && green <= 255, "Invalid green component")
        
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
        
    }
    
    convenience init(rgb: Int) {
        
        self.init(red: (rgb >> 16) & 0xFF,green: (rgb >> 8) & 0xFF,blue: rgb & 0xFF)
        
    }
    
}
