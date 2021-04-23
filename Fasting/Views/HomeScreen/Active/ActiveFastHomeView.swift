//
//  ActiveTimerView.swift
//  Fasting
//
//  Created by Zach McGaughey on 4/20/21.
//

import Combine
import SwiftUI


struct ActiveFastHomeView: View {
  
  @EnvironmentObject var appModel: AppModel
  @ObservedObject var fast: FastModel
  
  @StateObject var progressViewModel: FastProgressUpdatingViewModel
  @AppStorage(UserDefaultKey.fastingGoal.rawValue) var fastingGoal: FastingGoal = .sixteen
  
  private var namespace: Namespace.ID
  @State private var showingGoalSelection: Bool = false
  
  // End fast options
  @State private var showingEndOptions: Bool = false
  /// Our cachedEndDate is saved as soon as the user taps to end fast.
  /// We will commit this value, or update it depending on the users selection.
  @State private var cachedEndDate: Date? 
  
  init(fast: FastModel, namespace: Namespace.ID) {
    
    self.fast = fast
    self.namespace = namespace
    self._progressViewModel = StateObject(wrappedValue: FastProgressUpdatingViewModel(fast))
  }
      
  var body: some View {
    
    VStack {
      VStack(spacing: 32) {
        TextButtonGroup("Current Fasting Goal", buttonTitle: fastingGoal.caseTitle) {
          showingGoalSelection = true
        }
        .buttonStyle(PaddedButtonStyle())
        .sheet(isPresented: $showingGoalSelection) { FastingGoalPickerView(isPresented: $showingGoalSelection) }
        HStack(alignment: .firstTextBaseline, spacing: 16) {
          StartTimeInfoView(startDate: $fast.startDate)
            .frame(maxWidth: .infinity)
          EndTimeInfoView(referenceDate: fast.startDate.addingTimeInterval(fast.duration))
            .frame(maxWidth: .infinity)
        }
      }
      
      Spacer(minLength: 32)
      
      ZStack {
        RingProgress(viewModel: progressViewModel)
          .body
          .startColor(progressViewModel.progress < 1 ? .ringIncompleteStart : .ringCompleteStart)
          .endColor(progressViewModel.progress < 1 ? .ringIncompleteEnd : .ringCompleteEnd)
          .backgroundRingColor(progressViewModel.progress < 1 ? UIColor.ringIncompleteStart.withAlphaComponent(0.1) : UIColor.ringIncompleteEnd.withAlphaComponent(0.1))
          .ringWidth(32)
        VStack {
          Text("Elapsed time (\(StringFormatter.percent(from: progressViewModel.progress)))")
            .monospaced(font: .footnote)
            .foregroundColor(Color(UIColor.secondaryLabel))
          IntervalCountingView(referenceDate: fast.startDate)
            .monospaced(font: .largeTitle)
        }
        .matchedGeometryEffect(id: "interval", in: namespace)
      }
      .autoConnect(progressViewModel)
      
      Spacer(minLength: 24)
      
      Button("End Fast", action: endFastAction)
        .actionSheet(isPresented: $showingEndOptions) {
          ActionSheet(title: Text("Stop Fasting?"), buttons: [
            .default(Text("Save Fast"), action: saveFast),
            .default(Text("Edit End Time"), action: editEndTime),
            .destructive(Text("Delete Fast"), action: deleteFast),
            .cancel(Text("Cancel"), action: cancel)
          ])
        }
        .buttonStyle(PaddedButtonStyle())
        .matchedGeometryEffect(id: "action", in: namespace)
      
      Spacer(minLength: 48)
      
    }
    .padding()
    
  }
  
  // MARK: - Actions
  
  private func endFastAction() {
    cachedEndDate = Date()
    showingEndOptions = true
  }
  
  // MARK: Action sheet actions
  
  private func saveFast() {
    guard let endDate = cachedEndDate else { return }
    performSave(endDate)
  }
  
  private func editEndTime() {
    guard let endDate = cachedEndDate else { return }
    
    var picker = DatePickerSelectionView(
      date: .constant(endDate),
      minDate: fast.startDate,
      maxDate: Date(),
      presented: $appModel.appPresentation,
      animate: true
    )
    picker.onDateSelected = performSave
    
    withAnimation {
      appModel.appPresentation = AnyView(picker)
    }
  }
  
  private func performSave(_ endDate: Date) {
    withAnimation {
      appModel.endFast(fast, endDate: endDate)
    }
  }
  
  private func deleteFast() {
    withAnimation {
      appModel.deleteFast(fast)
    }
  }
  
  private func cancel() {
    cachedEndDate = nil
  }
  
}

struct ActiveTimerView_Previews: PreviewProvider {
  
  @Namespace static var namespace
  
  static var previews: some View {
    ActiveFastHomeView(fast: FastModel.preview, namespace: namespace)
      .environmentObject(AppModel.preview)
  }
}
