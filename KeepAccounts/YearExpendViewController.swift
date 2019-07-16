import UIKit

import Charts

class YearExpendViewController: UIViewController {
    
    @IBOutlet var pieChart: PieChartView!
    
    @IBOutlet var macStepper: UIStepper!
    
    @IBOutlet var iosStepper: UIStepper!
    
    var iosDataEntry = PieChartDataEntry(value: 0)
    
    var macDataEntry = PieChartDataEntry(value: 0)
    
    var numberOfDownloadsDataEntries = [PieChartDataEntry]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pieChart.chartDescription?.text = ""
        
        self.iosDataEntry.value = iosStepper.value
        
        self.iosDataEntry.label = "iOS"
        
        self.macDataEntry.value = macStepper.value
        
        self.macDataEntry.label = "macOS"
        
        self.numberOfDownloadsDataEntries = [iosDataEntry,macDataEntry]
        
        self.updateChartData()

       
    }
    
    @IBAction func changeiOS(_ sender: UIStepper) {
        
        self.iosDataEntry.value = sender.value
        
        self.updateChartData()
        
    }
    
    @IBAction func changeMac(_ sender: UIStepper) {
        
        self.macDataEntry.value = sender.value
        
        self.updateChartData()
    }
    
    func updateChartData() {
        
        let chartDataSet = PieChartDataSet(entries: numberOfDownloadsDataEntries, label: nil)
        
        let chartData = PieChartData(dataSet: chartDataSet)
        
        let colors = [UIColor.red,UIColor.blue]
        
        chartDataSet.colors = colors as! [NSUIColor]
        
        self.pieChart.data = chartData
        
    }
  

}
