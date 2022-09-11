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
  @ObservedObject var keyboardHeightHelper = KeyboardHeightHelper()
  
  var buttonColor: Color {
    model.entity.progress < 1 ?
    Color.buttonForegroundIncomplete :
    Color.buttonForegroundComplete
  }
  
  init(_ model: FastModel) {
    self.model = model
    // TODO: in iOS 16 use .scrollDismissesKeyboard(.interactively)
    UIScrollView.appearance().keyboardDismissMode = .interactive
  }
  
  var body: some View {
    
    ZStack {
      
      ScrollViewReader { reader in
        ScrollView {
          
          VStack {
            
            ZStack {
              RingView(ConstantUpdater(model.entity.progress))
                .applyProgressiveStyle(model.entity.progress)
                .thickness(32)
                .aspectRatio(contentMode: .fit)
              
              VStack {
                Text("Fasting Duration (\(model.progress.formatted(.percentRounded)))")
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
            
            TextEntryView(text: $model.note, textStyle: .constant(.body))
              .backgroundColor(.systemBackground)
              .cornerRadius(14)
              .overlay(
                RoundedRectangle(cornerRadius: 14)
                  .stroke(Color.secondaryLabel, lineWidth: 2)
              )
              .frame(height: 200)
              .overlay(alignment: .topLeading) {
                Text("Enter notes about your fast")
                  .foregroundColor(.secondaryLabel)
                  .padding(.top, 7)
                  .padding(.leading, 6)
                  .isHidden(model.note.isNilOrEmpty == false)
              }
              .padding([.leading, .trailing], 24)
              .id(1)
          }
        }
        .background(Color.secondarySystemBackground)
        .onChange(of: keyboardHeightHelper.keyboardHeight) { _ in
          withAnimation {
            reader.scrollTo(1)
          }
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
