import SwiftUI
import ExpoModulesCore
import ExpoUI

final class ExpoKeyeventSwiftUIViewProps: UIBaseViewProps {
  @Field var title: String = ""
}

struct ExpoKeyeventSwiftUIView: ExpoSwiftUI.View {
  @ObservedObject public var props: ExpoKeyeventSwiftUIViewProps

  var body: some View {
    VStack {
      Text(props.title)
        .font(.headline)
      Children()
    }
  }
}
