//
//  HelperFuncs.swift
//  MeatMarket
//  Copyright © 2019 YardenSwisa. All rights reserved.

import UIKit
import SDWebImage
import Firebase
struct  HelperFuncs {
    static func showToast(message : String, view: UIView) {
        let toastLabel = UILabel(frame: CGRect(x: view.frame.size.width/2 - 150 , y: view.frame.size.height-100, width: 300 , height: 60))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        toastLabel.numberOfLines = 0
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.2, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }

    static func getReadableDate(timeStamp: Double) -> String? {
        let date = Date(timeIntervalSince1970: timeStamp)
        let dateFormatter = DateFormatter()
        
        if Calendar.current.isDateInTomorrow(date) {
            return "Tomorrow"
        } else if Calendar.current.isDateInYesterday(date) {
            return "Yesterday"
        } else if dateFallsInCurrentWeek(date: date) {
            if Calendar.current.isDateInToday(date) {
                dateFormatter.dateFormat = "dd.MM.yyyy HH:MM "
                return dateFormatter.string(from: date)
            } else {
                dateFormatter.dateFormat = "EEEE"
                return dateFormatter.string(from: date)
            }
        } else {
            dateFormatter.dateFormat = "MMM dd, yyyy"
            return dateFormatter.string(from: date)
        }
    }
    
    static func dateFallsInCurrentWeek(date: Date) -> Bool {
        let currentWeek = Calendar.current.component(Calendar.Component.weekOfYear, from: Date())
        let datesWeek = Calendar.current.component(Calendar.Component.weekOfYear, from: date)
        return (currentWeek == datesWeek)
    }
}
//MARK: Extensions
extension UIImageView {
//    public func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
//        let maskPath = UIBezierPath(roundedRect: bounds,
//                                    byRoundingCorners: corners,
//                                    cornerRadii: CGSize(width: radius, height: radius))
//        let shape = CAShapeLayer()
//        shape.path = maskPath.cgPath
//        layer.mask = shape
//    }
    
//    public func loadImageWithURL(imageViewForGIF: UIImageView, imageURL:String){
//        let urlImage = URL(string: imageURL)
//        imageViewForGIF.sd_setImage(with: urlImage)
//    }
}



