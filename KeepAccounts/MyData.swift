import Foundation

import UIKit

class MyData {

    var date: Date
    
    var projectName: String?
    
    var price: String?
    
    var incomeExpend: String?
    
    var address: String?
    
    var round: String?
    
    var image: UIImage?
    
    init(date: Date , project: String? , price: String?, incomeExpend: String? , address: String? , round: String? , image: UIImage? ) {
        
        self.date = date
        
        self.projectName = project
        
        self.price = price
        
        self.incomeExpend = incomeExpend
        
        self.address = address
        
        self.round = round
        
        self.image = image
        
    }
    
    convenience init(date: Date) {
        
        self.init(date: date, project: nil, price: nil, incomeExpend: nil, address: nil, round: nil, image: nil)
        
    }
    
    
    func thumbnailImage() -> UIImage? {
        
        if let image =  self.image {

            let thumbnailSize = CGSize(width:50, height:50)

            let scale = UIScreen.main.scale
            
            UIGraphicsBeginImageContextWithOptions(thumbnailSize,false,scale)
           
            let widthRatio = thumbnailSize.width / image.size.width;

            let heightRadio = thumbnailSize.height / image.size.height;

            let ratio = max(widthRatio,heightRadio);

            let imageSize = CGSize(width:image.size.width*ratio,height: image.size.height*ratio);

            //如果要切圓形請加下面兩行
//            let circlePath = UIBezierPath(ovalIn: CGRect(x: 0,y: 0,width: thumbnailSize.width,height: thumbnailSize.height))
//
//            circlePath.addClip()

            image.draw(in:CGRect(x: -(imageSize.width-thumbnailSize.width)/2.0,y: -(imageSize.height-thumbnailSize.height)/2.0,
                                 width: imageSize.width,height: imageSize.height))
            
            let smallImage = UIGraphicsGetImageFromCurrentImageContext();
            
            UIGraphicsEndImageContext();

            return smallImage
        }

        else {
    
            return nil;

        }

    }
    
}
