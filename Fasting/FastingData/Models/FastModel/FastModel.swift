//
//  FastEntry.swift
//  Fasting
//
//  Created by Zach McGaughey on 4/22/21.
//

import Combine
import CoreData
import FastStorage
import Foundation
import Logging
import OSLog

/// Wrapper data model around our CoreData entity
final class FastModel: ObservableObject, Identifiable {

  private enum UpdateType {
    case startDate(Date)
    case endDate(Date?)
    case duration(TimeInterval)
    case note(String?)
    case mood(Int16?)
  }

  let logger = Logger.create(.dataModel)

  /// Our managed object reference
  let entity: Fast
  
  @Published var startDate: Date
  @Published var endDate: Date?
  @Published var duration: TimeInterval
  @Published var note: String?
  @Published var mood: Int16?
  
  var progress: Double {
    entity.currentInterval / entity.targetInterval
  }

  private var cancellables: Set<AnyCancellable> = .init()

  // MARK: - Lifecycle
  
  init(_ fast: Fast) {
    self.entity = fast
    self.startDate = fast.startDate!
    self.endDate = fast.endDate
    self.duration = fast.targetInterval
    self.note = fast.note
    self.mood = fast.mood

    logger.trace("FastModel created from: \(fast.description, privacy: .private)")
    
    setupPersistSubscription()
  }
  
  deinit {
    logger.trace("FastModel deinit")
  }
  
  // MARK: - Data Persistance
  
  /// Since this data model mirrors our CoreData entity, when changes are made
  /// to this class, we want to persist those in CoreData. This sets up bindings to
  /// allow for that.
  private func setupPersistSubscription() {

    let startDate = $startDate.map(UpdateType.startDate).dropFirst().eraseToAnyPublisher()
    let endDate = $endDate.map(UpdateType.endDate).dropFirst().eraseToAnyPublisher()
    let duration = $duration.map(UpdateType.duration).dropFirst().eraseToAnyPublisher()
    let note = $note.map(UpdateType.note).dropFirst().debounce(for: .seconds(2), scheduler: RunLoop.main).eraseToAnyPublisher()
    let mood = $mood.map(UpdateType.mood).dropFirst().eraseToAnyPublisher()

    let subscribedUpdates: [AnyPublisher<UpdateType, Never>] = [
      startDate,
      endDate,
      duration,
      note,
      mood
    ]

    Publishers.MergeMany(subscribedUpdates)
      .sink { [weak self] in
        self?.persistUpdate($0)
      }
      .store(in: &cancellables)


    Publishers.CombineLatest3($startDate, $endDate, $duration)
      .sink { (startDate: Date, endDate: Date?, duration: TimeInterval) in

        // Update notifications on change
        if endDate == nil {
          let targetCompletionDate: Date = startDate.addingTimeInterval(duration)
          NotificationManager.shared.requestNotification(forDeliveryAt: targetCompletionDate)

        } else {
          // End date was not nil, cancel notifications
          NotificationManager.shared.cancelNotification()
        }

      }
      .store(in: &cancellables)

  }

  private func persistUpdate(_ update: UpdateType) {

    guard let context = entity.managedObjectContext else {
      logger.warning("FastModel entity did not have a managedObjectContext. Aborting save")
      return
    }

    switch update {
    case .startDate(let date):
      logger.trace("Updating fast start date")
      entity.startDate = date

    case .endDate(let date):
      logger.trace("Updating fast end date")
      entity.endDate = date

    case .duration(let duration):
      logger.trace("Updating fast duration")
      entity.targetInterval = duration

    case .note(let note):
      logger.trace("Updating fast note")
      entity.note = note

    case .mood(let mood):
      logger.trace("Updating fast mood")
      entity.mood = mood ?? 0
    }

    guard context.hasChanges else {
      logger.debug("FastModel has no changes, aborting update")
      return
    }

    do {
      try context.save()
      logger.trace("FastModel save completed")

    } catch {
      logger.error("Error saving entity to disk: \(error.localizedDescription)")
    }

  }

}
