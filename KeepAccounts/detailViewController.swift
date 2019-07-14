import UIKit

import CoreData

class detailViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    var allDataArray : [MyData]!
    
    var formatter: DateFormatter {
        
        let formatter = DateFormatter()
        
        formatter.locale = Locale(identifier: "zh_TW")
        
        formatter.dateFormat = "yyyy年 MM月 dd日"
        
        return formatter
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.tableView.delegate = self
        
        self.tableView.dataSource = self
        
        self.queryFromCoreData()

    }
    
    func queryFromCoreData () {
        
        let moc = CoreDataHelper.shared.managedObjectContext()
        
        let fetchRequest = NSFetchRequest<MyData>(entityName:"MyData")
        
        moc.performAndWait {
            
            do {
                
                self.allDataArray = try moc.fetch(fetchRequest) as [MyData]
                
            }
                
            catch {
                
                print("error\(error)")
                
            }
            
        }
        
        self.tableView.reloadData()
        
    }

}

extension detailViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 220
        
    }

}

extension detailViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.allDataArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath) as! DetilCell
        
        cell.projectLab.text = self.allDataArray[indexPath.row].projectName
        
        let date = self.allDataArray[indexPath.row].date as! Date
        
        cell.dateLab.text = self.formatter.string(from: date)
        
        if self.allDataArray[indexPath.row].incomeExpend == "支出" {
            
            cell.priceLab.textColor = UIColor.red
            
            cell.priceLab.text = self.allDataArray[indexPath.row].price! + "$ "
            
        }
        
        if self.allDataArray[indexPath.row].incomeExpend == "收入" {
            
            cell.priceLab.textColor = UIColor(rgb: 0x009100)
            
            cell.priceLab.text = "+" + self.allDataArray[indexPath.row].price! + "$ "
            
        }
        
        cell.addressLab.text = self.allDataArray[indexPath.row].address
        
        cell.roundLab.text =  self.allDataArray[indexPath.row].round
        
        if let thumbnailImage = self.allDataArray[indexPath.row].thumbnailImage() {
            
            cell.photoImage.image = thumbnailImage
            
        }
        else {
            
            cell.photoImage.image = UIImage(named: "account")
            
        }
        
        if self.allDataArray[indexPath.row].address == "" {
            
            cell.addressLab.text = "無填寫此筆資料"
            
        }
        
        if self.allDataArray[indexPath.row].round == "" {
            
            cell.roundLab.text = "無填寫此筆資料"
            
        }
        
        return cell
        
    }
    
}
