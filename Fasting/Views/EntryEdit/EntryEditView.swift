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

  @ObservedObject var model: FastModel
  @State var presented: AnyView?
  
  var buttonColor: Color {
    model.entity.progress < 1 ?
    Color.buttonForegroundIncomplete :
    Color.buttonForegroundComplete
  }
  
  init(_ model: FastModel) {
    self.model = model
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
              Text("Fasting Duration (\(model.progress.formatted(.percent))")
                .monospaced(font: .footnote)
                .foregroundColor(Color(UIColor.secondaryLabel))
              Text(model.entity.currentInterval.formatted(.shortDuration))
                .monospaced(font: .largeTitle)
            }
          }
          
          HStack {
            Button(model.startDate.formatted(date: .omitted, time: .shortened)) {
              editStartTime()
            }
            Text(" - ")
            Button(model.endDate?.formatted(date: .omitted, time: .shortened) ?? "?") {
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
            // TODO: When TextEditor has placeholder, remove this
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
      .background(Color.secondarySystemBackground)
      
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
