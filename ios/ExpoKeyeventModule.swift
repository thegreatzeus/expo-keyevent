import ExpoModulesCore
import UIKit
import GameController

extension UIApplication {
    private static let swizzleSendEventOnce: Void = {
        let originalSelector = #selector(UIApplication.sendEvent(_:))
        let swizzledSelector = #selector(UIApplication.swizzled_sendEvent(_:))
        
        guard let originalMethod = class_getInstanceMethod(UIApplication.self, originalSelector),
              let swizzledMethod = class_getInstanceMethod(UIApplication.self, swizzledSelector) else { return }
        
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }()
    
    @objc class func swizzleSendEvent() {
        _ = swizzleSendEventOnce
    }
    
    static var consumeEvents: Bool = false
    
    @objc func swizzled_sendEvent(_ event: UIEvent) {
        var consumed = false
        if let pressesEvent = event as? UIPressesEvent {
            for press in pressesEvent.allPresses {
                if let key = press.key {
                    var eventType = ""
                    switch press.phase {
                    case .began:
                        eventType = "onKeyDown"
                    case .ended, .cancelled:
                        eventType = "onKeyUp"
                    default:
                        break
                    }
                    
                    if !eventType.isEmpty {
                        let payload: [String: Any] = [
                            "key": key.characters,
                            "keyCode": key.keyCode.rawValue,
                            "modifierFlags": key.modifierFlags.rawValue
                        ]
                        NotificationCenter.default.post(name: NSNotification.Name("ExpoKeyeventNotification"), object: nil, userInfo: [
                            "type": eventType,
                            "payload": payload
                        ])
                        
                        if UIApplication.consumeEvents {
                            consumed = true
                        }
                    }
                }
            }
        }
        // Call the original implementation only if we shouldn't consume it
        if !consumed {
            self.swizzled_sendEvent(event)
        }
    }
}

public class ExpoKeyeventModule: Module {
  private var isListening = false
  private var observer: NSObjectProtocol?
  private var gamepadObserver: NSObjectProtocol?

  public func definition() -> ModuleDefinition {
    Name("ExpoKeyevent")

    Events("onKeyDown", "onKeyUp")

    Function("startListening") { (consumeEvents: Bool?) in
      UIApplication.consumeEvents = consumeEvents ?? false
      if !self.isListening {
          UIApplication.swizzleSendEvent()
          self.observer = NotificationCenter.default.addObserver(forName: NSNotification.Name("ExpoKeyeventNotification"), object: nil, queue: .main) { [weak self] notification in
              guard let self = self,
                    self.isListening,
                    let userInfo = notification.userInfo,
                    let type = userInfo["type"] as? String,
                    let payload = userInfo["payload"] as? [String: Any] else { return }
              
              self.sendEvent(type, payload)
          }
          
          self.gamepadObserver = NotificationCenter.default.addObserver(forName: .GCControllerDidConnect, object: nil, queue: .main) { [weak self] notification in
              guard let controller = notification.object as? GCController else { return }
              self?.setupGamepad(controller)
          }
          
          for controller in GCController.controllers() {
              self.setupGamepad(controller)
          }

          self.isListening = true
      }
    }
    
    Function("stopListening") {
      if self.isListening {
          if let observer = self.observer {
              NotificationCenter.default.removeObserver(observer)
              self.observer = nil
          }
          if let gamepadObserver = self.gamepadObserver {
              NotificationCenter.default.removeObserver(gamepadObserver)
              self.gamepadObserver = nil
          }
          self.isListening = false
      }
    }

    OnDestroy {
      if let observer = self.observer {
          NotificationCenter.default.removeObserver(observer)
      }
      if let gamepadObserver = self.gamepadObserver {
          NotificationCenter.default.removeObserver(gamepadObserver)
      }
    }
  }

  private func setupGamepad(_ controller: GCController) {
      let elements = controller.physicalInputProfile.allElements
      for element in elements {
          if let button = element as? GCControllerButtonInput {
              setupButtonHandler(button)
          } else if let dpad = element as? GCControllerDirectionPad {
              setupButtonHandler(dpad.up)
              setupButtonHandler(dpad.down)
              setupButtonHandler(dpad.left)
              setupButtonHandler(dpad.right)
          }
      }
  }

  private func setupButtonHandler(_ button: GCControllerButtonInput) {
      button.pressedChangedHandler = { [weak self] (btn, value, pressed) in
          guard let self = self, self.isListening else { return }
          
          let type = pressed ? "onKeyDown" : "onKeyUp"
          let key = btn.localizedName ?? btn.aliases.first ?? "Gamepad Button"
          
          let payload: [String: Any] = [
              "key": key,
              "keyCode": 0,
              "modifierFlags": 0
          ]
          
          self.sendEvent(type, payload)
      }
  }
}
