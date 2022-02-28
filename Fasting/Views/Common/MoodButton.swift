//
//  MoodButton.swift
//  Fasting
//
//  Created by Zach McGaughey on 2/28/22.
//

import SwiftUI

struct MoodButton: View {

  @Binding var mood: Int16?
  var tintColor: Color
  @State private var showingOptions: Bool = false

  var body: some View {

    Menu(content: {

      Section {
        Button("Great!", action: { optionSelected(5) })
        Button("Good", action: { optionSelected(4) })
        Button("Okay", action: { optionSelected(3) })
        Button("Bad", action: { optionSelected(2) })
        Button("Awful", action: { optionSelected(1) })
      }
      Button("Clear Mood", action: { optionSelected(nil) })

    }, label: {
      ZStack {
        Circle().foregroundColor(tintColor.opacity(0.1))
          .frame(width: 48, height: 48)

        if let mood = mood, mood > 0 {
          switch mood {
          case 1:
            Text("😫").font(.system(size: 28))

          case 2:
            Text("🙁").font(.system(size: 28))

          case 3:
            Text("😐").font(.system(size: 28))

          case 4:
            Text("🙂").font(.system(size: 28))

          default:
            Text("😀").font(.system(size: 28))

          }

        } else {
          Image(systemName: "face.smiling")
            .font(.system(size: 28, weight: .bold))
            .foregroundColor(tintColor.opacity(0.7))
        }

      }

    })

  }

  private func optionSelected(_ value: Int16?) {
    mood = value
  }

}

struct MoodButton_Previews: PreviewProvider {
  @State static var mood: Int16?

  static var previews: some View {
    MoodButton(mood: $mood, tintColor: Color.buttonForegroundIncomplete)
  }
}
