//
//  UIApplication+openAppStore.swift
//  puutie
//
//  Created by Gurhan on 11/20/25.
//

import UIKit

extension UIApplication {
    func openAppStore(for link: String) {
        guard let url = URL(string: link),
            canOpenURL(url)
        else {
            return
        }
        open(
            url,
            options: [:],
            completionHandler: { (success: Bool) in
                if success {
                    print("Launching \(url) was successful")
                }
            }
        )
    }
}
