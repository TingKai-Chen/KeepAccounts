import Foundation

import CoreData

import UIKit

extension MyData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MyData> {
        
        return NSFetchRequest<MyData>(entityName: "MyData")
        
    }

    @NSManaged public var address: String?
    
    @NSManaged public var date: NSDate?
    
    @NSManaged public var incomeExpend: String?
    
    @NSManaged public var price: String?
    
    @NSManaged public var projectName: String?
    
    @NSManaged public var round: String?
    
    @NSManaged public var imageStr: String?
    
    var image: UIImage? {
        
        set {
            
            let imageData = image!.jpegData(compressionQuality: 1.0)
            
            let strBase64 = imageData!.base64EncodedString(options: .lineLength64Characters)
           
            self.imageStr = strBase64
            
        }
        
        get {
            
            let dataDecoded :Data = Data(base64Encoded: self.imageStr!, options: .ignoreUnknownCharacters)!
            
            let decodedimage = UIImage(data: dataDecoded)
            
            return decodedimage
            
        }
        
    }
    
    func thumbnailImage() -> UIImage? {
        
        if let image = self.image {
            
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
