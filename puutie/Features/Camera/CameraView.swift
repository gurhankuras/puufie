//
//  CameraView.swift
//  puutie
//
//  Created by Gurhan on 11/19/25.
//

import SwiftUI
import UIKit

struct CameraView: UIViewControllerRepresentable {
    typealias UIViewControllerType = CameraViewController
    
    func makeUIViewController(context: Context) -> CameraViewController {
        return CameraViewController()
    }
    
    func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {
        
    }
    
}
