//
//  UIViewController+Extension.swift
//  Netflix Clone
//
//  Created by Burak AKCAN on 20.09.2022.
//

import Foundation
import UIKit

extension UIViewController{
    func presentAlertOnMainThread(title:String,message:String,buttonTitle:String){
        DispatchQueue.main.async {
            let alertVc = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertVc.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            alertVc.modalPresentationStyle = .overFullScreen
            alertVc.modalTransitionStyle = .crossDissolve
            self.present(alertVc, animated: true)
        }
    }
}
