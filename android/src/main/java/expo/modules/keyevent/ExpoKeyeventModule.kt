package expo.modules.keyevent

import expo.modules.kotlin.modules.Module
import expo.modules.kotlin.modules.ModuleDefinition
import expo.modules.ui.ExpoUIView
import expo.modules.kotlin.records.recordFromMap
import expo.modules.ui.ModifierRegistry

class ExpoKeyeventModule : Module() {
  override fun definition() = ModuleDefinition {
    Name("ExpoKeyevent")

    Events("onChange")

    Constant("PI") {
      Math.PI
    }

    Function("hello") {
      "Hello world! 👋"
    }

    AsyncFunction("setValueAsync") { value: String ->
      sendEvent("onChange", mapOf(
        "value" to value
      ))
    }

    View(ExpoKeyeventView::class) {
      // Defines an event that the view can send to JavaScript.
      Events("onTap")
    }

    Class(ExpoKeyeventModuleSharedObject::class) {
      Constructor {
        val instance = ExpoKeyeventModuleSharedObject(appContext)
        return@Constructor instance
      }

      Property("count")
        .get { ref: ExpoKeyeventModuleSharedObject ->
          ref.count
        }
        .set { ref: ExpoKeyeventModuleSharedObject, count: Int ->
          ref.count = count
        }
    }

    ExpoUIView<ExpoKeyeventComposeViewProps>("ExpoKeyeventComposeView") {
      Content { props ->
        ExpoKeyeventComposeViewContent(props)
      }
    }

    OnCreate {
      ModifierRegistry.register("expoKeyeventComposeModifier") { params, _, _, _ ->
        recordFromMap<ExpoKeyeventComposeModifierParams>(params).toModifier()
      }
    }
  }
}
