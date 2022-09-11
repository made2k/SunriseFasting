//
//  EntryEditView.swift
//  Fasting
//
//  Created by Zach McGaughey on 9/10/22.
//

import FastStorage
import Formatting
import RingView
import SwiftUI

struct EntryEditView: View {
  
  private static let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.timeStyle = .short
    return formatter
  }()
  
  @Environment(\.dismiss) var dismiss
  
  @ObservedObject var model: FastModel
  
  @State var presented: AnyView?
  
  var buttonColor: Color {
    model.entity.progress < 1 ? Color.buttonForegroundIncomplete : Color.buttonForegroundComplete
  }
  
  init(_ model: FastModel) {
    self.model = model
    
    UITextView.appearance().backgroundColor = .secondarySystemBackground
  }
  
  var body: some View {
    
    ZStack {
      ScrollView {
        VStack {
          ZStack {
            
          RingView(ConstantUpdater(model.entity.progress))
            .applyProgressiveStyle(model.entity.progress)
            .thickness(32)
            .aspectRatio(contentMode: .fit)
            
            VStack {
              Text("Fasting Duration (\(StringFormatter.percent(from: model.progress)))")
                .monospaced(font: .footnote)
                .foregroundColor(Color(UIColor.secondaryLabel))
              Text(model.entity.currentInterval.formatted(.shortDuration))
                .monospaced(font: .largeTitle)
            }

            
          }
          
          HStack {
            Button(Self.dateFormatter.string(from: model.startDate)) {
              editStartTime()
            }
            Text(" - ")
            Button(Self.dateFormatter.string(from: model.endDate!)) {
              editEndTime()
            }
          }
          .buttonStyle(PaddedButtonStyle(foregroundColor: buttonColor))

          HStack {
            Spacer()
            MoodButton(mood: $model.mood, tintColor: model.entity.progress < 1 ? Color.buttonForegroundIncomplete : Color.buttonForegroundComplete)
              .padding(.trailing, 24)
          }
          
          ZStack {
            if model.note == nil || model.note!.isEmpty {
              TextEditor(text: .constant("Notes on this fast"))
                .foregroundColor(Color.secondaryLabel)
                .disabled(true)
            }
            TextEditor(text: $model.note ?? "")
              .foregroundColor(Color.label)
              .opacity(model.note.isNilOrEmpty ? 0.25 : 1)
          }
          .font(.body)
          .cornerRadius(14)
          .overlay(
            RoundedRectangle(cornerRadius: 14)
              .stroke(Color.secondaryLabel, lineWidth: 2)
          )
          .frame(minHeight: 200, maxHeight: 200)
          .padding([.leading, .trailing], 24)
          
        }
      }
      
      if let presented = presented {
        presented
          .zIndex(2)
      }
      
      
    }
  }
  
  private func editStartTime() {
    
    var picker = DatePickerSelectionView(
      date: .constant(model.startDate),
      minDate: nil,
      maxDate: model.endDate,
      presented: $presented,
      animate: true
    )
    picker.onDateSelected = {
      model.startDate = $0
    }
    
    withAnimation {
      presented = AnyView(picker)
    }
    
  }
  
  private func editEndTime() {
    
    var picker = DatePickerSelectionView(
      date: .constant(model.endDate!),
      minDate: model.startDate,
      maxDate: Date(),
      presented: $presented,
      animate: true
    )
    picker.onDateSelected = {
      model.endDate = $0
    }
    
    withAnimation {
      presented = AnyView(picker)
    }
    
  }
  
}

struct EntryEditView_Previews: PreviewProvider {
  static var previews: some View {
    EntryEditView(FastModel.completedPreview)
  }
}


func ??<T>(lhs: Binding<Optional<T>>, rhs: T) -> Binding<T> {
  Binding(
    get: { lhs.wrappedValue ?? rhs },
    set: { lhs.wrappedValue = $0 }
  )
}

extension Optional where Wrapped == String {
  
  var isNilOrEmpty: Bool {
    guard let self = self else { return true }
    return self.isEmpty
  }
  
}
