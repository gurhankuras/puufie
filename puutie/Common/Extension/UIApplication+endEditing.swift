//
//  UIApplication+endEditing.swift
//  puutie
//
//  Created by Gurhan on 11/20/25.
//

import UIKit

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder),
                   to: nil, from: nil, for: nil)
    }
}
