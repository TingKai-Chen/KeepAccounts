import UIKit

import Charts

import CoreData

class MonthIncomeViewController: UIViewController {
    
    @IBOutlet var pieChart: PieChartView!
    
    @IBOutlet var yearLab: UILabel!
    
    @IBOutlet weak var monthLab: UILabel!
    
    var dataArray : [MyData]?
    
    var startDate = Date()
    
    var endDate = Date()
    
    var year = 2019
    
    var startMonth = 01
    
    var endMonth = 02
    
    var formatter: DateFormatter {
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy-MM-dd"
        
        return formatter
        
    }
    
    var numberOfDownloadsDataEntries = [PieChartDataEntry]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.queryFromCoreData()
        
        self.updateChartData()
        
        self.yearLab.text = "西元 \(self.year) 年"
        
        self.monthLab.text = "\(self.startMonth)月"
        
        self.pieChart.backgroundColor = UIColor(rgb:0xD4FFD4)
        
        self.view.backgroundColor = UIColor(rgb:0xD4FFD4)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.tabBarController?.navigationItem.title = "月收入"
        
    }
    
    func updateChartData() {
        
        let chartDataSet = PieChartDataSet(entries: self.numberOfDownloadsDataEntries, label: nil)
        
        let chartData = PieChartData(dataSet: chartDataSet)
        
        for _ in 0 ..< self.numberOfDownloadsDataEntries.count {
            
            chartDataSet.colors.append(UIColor.random)
            
        }
        
        self.pieChart.data = chartData
        
    }
    
    func queryFromCoreData () {
        
        self.startDate = self.formatter.date(from: "\(self.year)-\(self.startMonth)-01")!
        
        self.endDate = self.formatter.date(from: "\(self.year)-\(self.endMonth)-01")!
        
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
                
                let trafficsCount = self.dataArray?.filter({ $0.category == "工資" }).count
                
                dict["工資"] = trafficsCount
                
                let foodsCount = self.dataArray?.filter({ $0.category == "獎金" }).count
                
                dict["獎金"] = foodsCount
                
                let communicationCount = self.dataArray?.filter({ $0.category == "外快" }).count
                
                dict["外快"] = communicationCount
                
                let apparelCount = self.dataArray?.filter({ $0.category == "報銷" }).count
                
                dict["報銷"] = apparelCount
                
                let liveCount = self.dataArray?.filter({ $0.category == "投資" }).count
                
                dict["投資"] = liveCount
                
                let entertainmentCount = self.dataArray?.filter({ $0.category == "其他" }).count
                
                dict["其他"] = entertainmentCount
                
                let newdict = dict.filter({$1 > 0})
                
                for item in newdict {
                    
                    self.numberOfDownloadsDataEntries.append(PieChartDataEntry(value: Double(item.value), label: item.key))
                    
                }
                
            }
                
            catch {
                
                print("error\(error)")
                
            }
            
        }
        
    }
    
    @IBAction func addYear(_ sender: Any) {
        
        self.year += 1
        
        self.yearLab.text = "西元 \(self.year) 年"
        
        self.numberOfDownloadsDataEntries = []
        
        self.queryFromCoreData()
        
        self.updateChartData()
        
    }
    
    @IBAction func subtractYear(_ sender: Any) {
        
        self.year -= 1
        
        self.yearLab.text = "西元 \(self.year) 年"
        
        self.numberOfDownloadsDataEntries = []
        
        self.queryFromCoreData()
        
        self.updateChartData()
        
        
    }
    
    @IBAction func addMonth(_ sender: Any) {
        
        self.startMonth += 1
        
        self.endMonth += 1
        
        if self.endMonth == 13 {
            
            self.endMonth = 01
            
        }
        
        if self.startMonth == 13 {
            
            self.startMonth = 01
            
        }
        
        self.monthLab.text = "\(self.startMonth)月"
        
        self.numberOfDownloadsDataEntries = []
        
        self.queryFromCoreData()
        
        self.updateChartData()
        
    }
    
    
    
    @IBAction func subtractMonth(_ sender: Any) {
        
        self.startMonth -= 1
        
        self.endMonth -= 1
        
        if self.endMonth == 0 {
            
            self.endMonth = 12
            
        }
        
        if self.startMonth == 0 {
            
            self.startMonth = 12
            
        }
        
        self.monthLab.text = "\(self.startMonth)月"
        
        self.numberOfDownloadsDataEntries = []
        
        self.queryFromCoreData()
        
        self.updateChartData()
        
    }
    

}
