//
//  ActivityView.swift
//  Fasting
//
//  Created by Zach McGaughey on 8/14/21.
//

import SwiftUI

struct ActivityView: UIViewControllerRepresentable {
  
  let activityItems: [Any]
  let applicationActivities: [UIActivity]?
  
  func makeUIViewController(context: Context) -> some UIViewController {
    UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
  }
  
  func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    /* Do nothing here*/
  }

}
