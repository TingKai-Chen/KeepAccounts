import UIKit

import JTAppleCalendar

class ViewController: UIViewController {
    
    @IBOutlet weak var totalPriceLab: UILabel!
    
    @IBOutlet weak var dateLab: UILabel!
    
    @IBOutlet var calendarView: JTAppleCalendarView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var startAccountBtn: UIButton!
    
    var dataArray : [Data] = [] {
        
        didSet {
            
            let totalPrice = self.dataArray.compactMap({Int($0.price)}).reduce(0, {$0 + $1})
            
            if totalPrice < 0 {
                
                self.totalPriceLab.textColor = UIColor.red
                
                self.totalPriceLab.text = String(totalPrice) + "$"
                
            }
            
            else if totalPrice == 0 {
                
                self.totalPriceLab.textColor = UIColor.black
                
                self.totalPriceLab.text = String(totalPrice) + "$"
                
            }
            
            else {
                
                self.totalPriceLab.textColor = UIColor.blue
                
                self.totalPriceLab.text = String(totalPrice) + "$"
                
            }
            
        }
        
    }
    
    var n = 1
    
    var c = -1
    
    var totalPrice = 0
    
    var date = Date()
    
    var startDate = Date()
    
    var endDate = Date()
    
    var formatter: DateFormatter {
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "dd-MMM-yyyy"
        
        return formatter
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.tableView.delegate = self
        
        self.tableView.dataSource = self
        
        self.navigationItem.rightBarButtonItem = editButtonItem
        
        self.startAccountBtn.clipsToBounds = true
        
        self.startAccountBtn.layer.cornerRadius = 10
        
        self.calendarView.layer.cornerRadius = 10
        
        self.calendarView.calendarDelegate = self
        
        self.calendarView.calendarDataSource = self
        
        self.calendarView.scrollDirection = .horizontal
        
        self.calendarView.scrollingMode = .stopAtEachCalendarFrame
        
        self.calendarView.showsHorizontalScrollIndicator = false
        
        self.totalPriceLab.text = String(self.totalPrice)
        
        self.calendarView.selectDates([self.endDate])
        
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        
        super.setEditing(editing, animated: true)
        
        self.tableView.setEditing(editing, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let deleteDataArray = self.dataArray.remove(at: indexPath.row)
            
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Segue" {
            
            let FormVC = segue.destination as! FormViewController
            
            FormVC.date = self.date
            
            FormVC.startDate = self.startDate
            
            FormVC.delegate = self
            
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
            
            //cell.selectedView.layer.cornerRadius =  5
            
            cell.selectedView.isHidden = false
            
            self.dataArray = []
            
            self.tableView.reloadData()
            
        }
        
        else {
            
            cell.selectedView.isHidden = true
            
        }
        
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
        
        formatter.dateFormat = "yyyy年MM月dd日"
        
        formatter.locale = Locale(identifier: "zh_TW")
        
        self.dateLab.text = formatter.string(from: self.date)
        
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
    
    func upDateData(data: Data) {
        
        self.dataArray.append(data)
    
        self.tableView.reloadData()
        
    }
    
}

extension ViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
}

extension ViewController : UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return dataArray.count

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! Cell
        
        cell.projectLab.text = self.dataArray[indexPath.row].project
        
        if self.dataArray[indexPath.row].incomeExpend == "支出" {
            
            cell.priceLab.textColor = UIColor.red
            
            cell.priceLab.text = self.dataArray[indexPath.row].price + "$ "
            
        }
        
        if self.dataArray[indexPath.row].incomeExpend == "收入" {
            
            cell.priceLab.textColor = UIColor.blue
                
            cell.priceLab.text = "+" + self.dataArray[indexPath.row].price + "$ "
            
        }
        
        return cell

    }

}
