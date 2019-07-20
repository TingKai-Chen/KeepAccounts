import UIKit

import Charts

import CoreData

class MonthExpendViewController: UIViewController {
    
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
        
        self.yearLab.text = "\(self.year)年"
        
        self.monthLab.text = "\(self.startMonth)月"
        
//        self.pieChart.backgroundColor = UIColor(rgb:0xD4FFD4)
        
        //self.view.backgroundColor = UIColor(rgb:0xD4FFD4)
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.tabBarController?.navigationItem.title = "月支出"
        
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
        
        self.startDate = self.formatter.date(from: "\(self.year)-\(self.startMonth)-01")!
        
        self.endDate = self.formatter.date(from: "\(self.year)-\(self.endMonth)-01")!
        
        let moc = CoreDataHelper.shared.managedObjectContext()
        
        let fetchRequest = NSFetchRequest<MyData>(entityName:"MyData")
        
        let expendPredicate = NSPredicate(format: "incomeExpend = %@","支出")
        
        let starDatePredicate = NSPredicate(format: "date > %@", self.startDate as NSDate)
        
        let endDatePredicate = NSPredicate(format: "date < %@", self.endDate as NSDate)
        
        let totalPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [expendPredicate,starDatePredicate,endDatePredicate])
        
        fetchRequest.predicate = totalPredicate
        
        moc.performAndWait {
            
            do {
                
                var dict = [String: Int]()
                
                self.dataArray = try moc.fetch(fetchRequest) as [MyData]
                
                let trafficsCount = self.dataArray?.filter({ $0.category == "交通" }).count
                
                dict["交通"] = trafficsCount
                
                let foodsCount = self.dataArray?.filter({ $0.category == "飲食" }).count
                
                dict["飲食"] = foodsCount
                
                let communicationCount = self.dataArray?.filter({ $0.category == "通訊" }).count
                
                dict["通訊"] = communicationCount
                
                let apparelCount = self.dataArray?.filter({ $0.category == "服飾" }).count
                
                dict["服飾"] = apparelCount
                
                let liveCount = self.dataArray?.filter({ $0.category == "居住" }).count
                
                dict["居住"] = liveCount
                
                let entertainmentCount = self.dataArray?.filter({ $0.category == "娛樂" }).count
                
                dict["娛樂"] = entertainmentCount
                
                let dailyCount = self.dataArray?.filter({ $0.category == "日常" }).count
                
                dict["日常"] = dailyCount
                
                let medicalCount = self.dataArray?.filter({ $0.category == "醫療" }).count
                
                dict["醫療"] = medicalCount
                
                let educationCount = self.dataArray?.filter({ $0.category == "教育" }).count
                
                dict["教育"] = educationCount
                
                let insuranceCount = self.dataArray?.filter({ $0.category == "保險" }).count
                
                dict["保險"] = insuranceCount
                
                let socialCount = self.dataArray?.filter({ $0.category == "社交" }).count
                
                dict["社交"] = socialCount
                
                let fitnessBeautyCount = self.dataArray?.filter({ $0.category == "健身美容" }).count
                
                dict["健身美容"] = fitnessBeautyCount
                
                let filialPietyCount = self.dataArray?.filter({ $0.category == "孝順養育" }).count
                
                dict["孝順養育"] = filialPietyCount
                
                let otherCount = self.dataArray?.filter({ $0.category == "其他" }).count
                
                dict["其他"] = otherCount
                
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
        
    }
    
    @IBAction func addYear(_ sender: Any) {
        
        self.year += 1
        
        self.yearLab.text = "\(self.year)年"
        
        self.numberOfDownloadsDataEntries = []
        
        self.queryFromCoreData()
        
        self.updateChartData()
        
    }
    
    @IBAction func subtractYear(_ sender: Any) {
        
        self.year -= 1
        
        self.yearLab.text = "\(self.year)年"
        
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
