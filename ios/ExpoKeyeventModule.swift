import ExpoModulesCore
import ExpoUI

public class ExpoKeyeventModule: Module {
  public func definition() -> ModuleDefinition {
    Name("ExpoKeyevent")

    Events("onChange")

    Constant("PI") {
      Double.pi
    }

    Function("hello") {
      return "Hello world! 👋"
    }

    AsyncFunction("setValueAsync") { (value: String) in
      self.sendEvent("onChange", [
        "value": value
      ])
    }

    View(ExpoKeyeventView.self) {
      Events("onTap")
    }

    Class(ExpoKeyeventModuleSharedObject.self) {
      Constructor { () -> ExpoKeyeventModuleSharedObject in
        return ExpoKeyeventModuleSharedObject()
      }

      Property("count") { (ref: ExpoKeyeventModuleSharedObject) -> Int in
        return ref.count
      }
      .set { (ref: ExpoKeyeventModuleSharedObject, count: Int) in
        ref.count = count
      }
    }

    ExpoUIView(ExpoKeyeventSwiftUIView.self)

    OnCreate {
      ViewModifierRegistry.register("expoKeyeventSwiftUIModifier") { params, appContext, _ in
        return try ExpoKeyeventSwiftUIModifier(from: params, appContext: appContext)
      }
    }

    OnDestroy {
      ViewModifierRegistry.unregister("expoKeyeventSwiftUIModifier")
    }
  }
}
