import UIKit

import Charts

import CoreData

class YearIncomeViewController: UIViewController {
    
    @IBOutlet var pieChart: PieChartView!
    
    @IBOutlet var yearLab: UILabel!
    
    @IBOutlet weak var leftBtn: UIButton!
    
    @IBOutlet weak var rightBtn: UIButton!
    
    var dataArray : [MyData]?
    
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
        
        self.queryFromCoreData()
        
        self.updateChartData()
        
        self.yearLab.text = "\(year)年"
        
        self.pieChart.backgroundColor = UIColor(rgb:0xBFFFFF)

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
    
    @IBAction func subtract(_ sender: Any) {
        
        self.year -= 1
        
        self.startYear -= 1
        
        self.endYear -= 1
        
        self.yearLab.text = "\(self.year)年"
        
        self.numberOfDownloadsDataEntries = []
        
        self.queryFromCoreData()
        
        self.updateChartData()
        
    }
    
    @IBAction func plus(_ sender: Any) {
        
        self.year += 1
        
        self.startYear += 1
        
        self.endYear += 1
        
        self.numberOfDownloadsDataEntries = []
        
        self.yearLab.text = "\(self.year)年"
        
        self.queryFromCoreData()
        
        self.updateChartData()
        
    }
    
}

