import UIKit

import Charts

import CoreData

class YearIncomeViewController: UIViewController {
    
    @IBOutlet var pieChart: PieChartView!
    
    @IBOutlet var yearLab: UILabel!
    
    @IBOutlet weak var leftBtn: UIButton!
    
    @IBOutlet weak var rightBtn: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var totalPrice: UILabel!
    
    var dataArray : [MyData] = [] {
        
        didSet {
            
            self.caculateSummary()
            
        }
        
    }
    
    var startDate = Date()
    
    var endDate = Date()
    
    var year = 2019
    
    var startYear = 2019
    
    var endYear = 2020
    
    var formatter: DateFormatter {
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy-MM-dd"
        
        return formatter
        
    }
    
    var numberOfDownloadsDataEntries = [PieChartDataEntry]()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        
        self.tableView.dataSource = self

        self.queryFromCoreData()
        
        self.updateChartData()
        
        self.yearLab.text = "\(year)/01/01~\(year)/12/31"
        
//        self.pieChart.backgroundColor = UIColor(rgb:0xD4FFD4)
        
        self.view.backgroundColor = UIColor(rgb:0xf0f0f0)
        
        self.tableView.backgroundColor = UIColor(rgb:0xf0f0f0)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.tabBarController?.navigationItem.title = "年收入"
        
    }
    
    func caculateSummary() {
        
        let totalPrice = self.dataArray.compactMap({Int($0.price!)}).reduce(0, {$0 + $1})
        
        self.totalPrice.text = "+" + String(totalPrice) + "$"
        
        self.totalPrice.textColor = UIColor(rgb: 0x009100)
        
    }
    
    func updateChartData() {
        
        let formatter = NumberFormatter()
        
        formatter.numberStyle = .percent
        
        formatter.maximumFractionDigits = 1
        
        formatter.multiplier = 1.0
        
        let chartDataSet = PieChartDataSet(entries: self.numberOfDownloadsDataEntries, label: nil)
        
        let chartData = PieChartData(dataSet: chartDataSet)
        
        chartDataSet.valueFormatter = DefaultValueFormatter(formatter:formatter)
        
        for _ in 0 ..< self.numberOfDownloadsDataEntries.count {
            
            chartDataSet.colors.append(UIColor.random)
            
        }
        
        self.pieChart.data = chartData
        
    }
    
    func queryFromCoreData () {
        
        self.startDate = self.formatter.date(from: "\(self.startYear)-01-01")!
        
        self.endDate = self.formatter.date(from: "\(self.endYear)-01-01")!
        
        let moc = CoreDataHelper.shared.managedObjectContext()
        
        let fetchRequest = NSFetchRequest<MyData>(entityName:"MyData")
        
        let expendPredicate = NSPredicate(format: "incomeExpend = %@","收入")
        
        let starDatePredicate = NSPredicate(format: "date > %@", self.startDate as NSDate)
        
        let endDatePredicate = NSPredicate(format: "date < %@", self.endDate as NSDate)
        
        let totalPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [expendPredicate,starDatePredicate,endDatePredicate])
        
        fetchRequest.predicate = totalPredicate
        
        moc.performAndWait {
            
            do {
                
                var dict = [String: Int]()
                
                self.dataArray = try moc.fetch(fetchRequest) as [MyData]
                
                let trafficsCount = self.dataArray.filter({ $0.category == "工資" }).count
                
                dict["工資"] = trafficsCount
                
                let foodsCount = self.dataArray.filter({ $0.category == "獎金" }).count
                
                dict["獎金"] = foodsCount
                
                let communicationCount = self.dataArray.filter({ $0.category == "外快" }).count
                
                dict["外快"] = communicationCount
                
                let apparelCount = self.dataArray.filter({ $0.category == "報銷" }).count
                
                dict["報銷"] = apparelCount
                
                let liveCount = self.dataArray.filter({ $0.category == "投資" }).count
                
                dict["投資"] = liveCount
                
                let entertainmentCount = self.dataArray.filter({ $0.category == "其他" }).count
                
                dict["其他"] = entertainmentCount
                
                let newDict = dict.filter({$1 > 0})
                
                let sum = newDict.values.reduce(0, { $0 + $1 })
                
                for item in newDict {
                    
                    self.numberOfDownloadsDataEntries.append(PieChartDataEntry(value: Double(item.value) * 100 / Double(sum), label: item.key))
                    
                }
                
            }
                
            catch {
                
                print("error\(error)")
                
            }
            
        }
        
        self.tableView.reloadData()
        
    }
    
    @IBAction func subtract(_ sender: Any) {
        
        self.year -= 1
        
        self.startYear -= 1
        
        self.endYear -= 1
        
       self.yearLab.text = "\(year)/01/01~\(year)/12/31"
        
        self.numberOfDownloadsDataEntries = []
        
        self.queryFromCoreData()
        
        self.updateChartData()
        
    }
    
    @IBAction func plus(_ sender: Any) {
        
        self.year += 1
        
        self.startYear += 1
        
        self.endYear += 1
        
        self.numberOfDownloadsDataEntries = []
        
        self.yearLab.text = "\(year)/01/01~\(year)/12/31"
        
        self.queryFromCoreData()
        
        self.updateChartData()
        
    }
    
}

extension YearIncomeViewController : UITableViewDelegate {
    
    
    
}

extension YearIncomeViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "YearIncomeCell", for: indexPath) as! YearIncomeCell
        
        cell.backgroundColor = UIColor(rgb:0xFFEE99)
        
        cell.layer.borderWidth = 1.0
        
        cell.layer.borderColor = UIColor.white.cgColor
        
        cell.categoryLab.text = dataArray[indexPath.row].category
        
        cell.projectLab.text = dataArray[indexPath.row].projectName
        
        cell.priceLab.text = "+" + dataArray[indexPath.row].price! + "$"
        
        cell.priceLab.textColor = UIColor(rgb: 0x009100)
        
        cell.categoryLab.textColor = UIColor(rgb: 0x009100)
        
        cell.addressLab.text = dataArray[indexPath.row].address
        
        if let thumbnailImage = self.dataArray[indexPath.row].thumbnailImage() {
            
            cell.photoImage.image = thumbnailImage
            
        }
        else {
            
            cell.photoImage.image = UIImage(named: "account")
            
        }
        
        if self.dataArray[indexPath.row].address == "" {
            
            cell.addressLab.text = "無填寫此筆資料"
            
        }
        
        return cell
        
    }
    
}

