//
//  DatePickerSelectionView.swift
//  Fasting
//
//  Created by Zach McGaughey on 4/21/21.
//

import Logging
import OSLog
import SwiftUI

struct DatePickerSelectionView: View {
  
  // Binding to update the date upon saving
  @Binding var persistedDate: Date
  // This view is typically bound to a presented state.
  @Binding var presented: AnyView?
  
  // We can modify this value without committing to our persisted data
  @State private var localDate: Date
  
  // Since native date pickers only allow for open and closed range
  // date values for min/max, we construct our date range and store
  // it for use
  private let dateRange: ClosedRange<Date>
  
  /// Optional callback on date selection, if this is not nil
  /// this callback will be called upon save and the `persistedDate` will
  /// **not** be updated.
  var onDateSelected: ((Date) -> Void)?
  
  init(
    date: Binding<Date>,
    minDate: Date? = nil,
    maxDate: Date? = nil,
    presented: Binding<AnyView?>,
    animate: Bool
  ) {
    self._persistedDate = date
    self._presented = presented
    self.dateRange = DatePickerRangeFactory.range(from: minDate, maxDate: maxDate)
    self._localDate = State<Date>(initialValue: date.wrappedValue)
  }
  
  var body: some View {
    
    ZStack {
      BlurView(style: .systemUltraThinMaterialDark)
        .ignoresSafeArea()
        .onTapGesture {
          withAnimation {
            presented = nil
          }
        }
      VStack(spacing:0) {
        DatePicker("", selection: $localDate, in: dateRange)
          .datePickerStyle(.graphical)
          .padding()
        // Empty separator view
        Rectangle()
          .frame(maxHeight: 1)
          .foregroundColor(.opaqueSeparator)
        HStack(spacing: 0) {
          Button(action: cancelButtonPressed) {
            Text("Cancel")
              .frame(maxWidth: .infinity, maxHeight: 48)
          }
          // Empty separator view
          Rectangle()
            .frame(maxWidth: 1, maxHeight: 48)
            .foregroundColor(.opaqueSeparator)
          Button(action: saveButtonPressed) {
            Text("Save")
              .frame(maxWidth: .infinity, maxHeight: 48)
          }
        }
      }
      .background(.background)
      .cornerRadius(12)
      .padding()
      
    }
    
  }
  
  // MARK: - Actions
  
  private func saveButtonPressed() {
    
    if let callback = onDateSelected {
      Logger.viewLogger.debug("DatePicker saving via callback")
      callback(localDate)
      
    } else {
      Logger.viewLogger.debug("DatePicker saving via binding")
      persistedDate = localDate
    }
    
    dismiss()
  }
  
  private func cancelButtonPressed() {
    dismiss()
  }
  
  private func dismiss() {
    withAnimation {
      presented = nil
    }
  }
  
}

struct DatePickerScreen_Previews: PreviewProvider {
  
  @State static var date: Date = Date()
  
  static var previews: some View {
    DatePickerSelectionView(date: $date, presented: .constant(nil), animate: false)
  }
}
