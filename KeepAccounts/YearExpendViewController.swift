import UIKit

import Charts

import CoreData

class YearExpendViewController: UIViewController {
    
    @IBOutlet var pieChart: PieChartView!
    
    @IBOutlet var macStepper: UIStepper!
    
    @IBOutlet var iosStepper: UIStepper!
    
    @IBOutlet var yearLab: UILabel!
    
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

        self.yearLab.text = "\(year)"
        
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
        
        self.yearLab.text = "\(self.year)"
        
        self.queryFromCoreData()
        
        self.updateChartData()
        
    }
    
    @IBAction func plus(_ sender: Any) {
        
        self.year += 1
        
        self.startYear += 1
        
        self.endYear += 1
        
        self.yearLab.text = "\(self.year)"
        
        self.queryFromCoreData()
        
        self.updateChartData()
        
    }
    
}

extension UIColor {
    
    static var random: UIColor {
        
        return UIColor(red: .random(in: 0...1),
                       
                       green: .random(in: 0...1),
                       
                       blue: .random(in: 0...1),
                       
                       alpha: 1.0)
    }
}
