import Foundation

import UIKit

class Data {

    var date = Date()
    
    var project = String()
    
    var price = String()
    
    var incomeExpend = String()
    
    var address = String()
    
    var round = String()
    
    var image : UIImage?
    
    func thumbnailImage() -> UIImage? {
        
        if let image =  self.image {

            let thumbnailSize = CGSize(width:20, height:20); //設定縮圖大小

            let scale = UIScreen.main.scale //找出目前螢幕的scale，視網膜技術為2.0
            //產生畫布，第一個參數指定大小,第二個參數true:不透明（黑色底）,false表示透明背景,scale為螢幕scale
            UIGraphicsBeginImageContextWithOptions(thumbnailSize,false,scale)
            //計算長寬要縮圖比例，取最大值MAX會變成UIViewContentModeScaleAspectFill
            //最小值MIN會變成UIViewContentModeScaleAspectFit

            let widthRatio = thumbnailSize.width / image.size.width;

            let heightRadio = thumbnailSize.height / image.size.height;

            let ratio = max(widthRatio,heightRadio);

            let imageSize = CGSize(width:image.size.width*ratio,height: image.size.height*ratio);

            //如果要切圓形請加下面兩行
//            let circlePath = UIBezierPath(ovalIn: CGRect(x: 0,y: 0,width: thumbnailSize.width,height: thumbnailSize.height))
//
//            circlePath.addClip()
//
            image.draw(in:CGRect(x: -(imageSize.width-thumbnailSize.width)/2.0,y: -(imageSize.height-thumbnailSize.height)/2.0,
                                 width: imageSize.width,height: imageSize.height))
            //取得畫布上的縮圖
            let smallImage = UIGraphicsGetImageFromCurrentImageContext();
            //關掉畫布
            UIGraphicsEndImageContext();

            return smallImage
        }

        else {
    
            return nil;

        }

    }
    
}
