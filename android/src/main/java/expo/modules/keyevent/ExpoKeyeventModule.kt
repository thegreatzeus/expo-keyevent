package expo.modules.keyevent

import android.view.KeyEvent
import android.view.Window
import expo.modules.kotlin.modules.Module
import expo.modules.kotlin.modules.ModuleDefinition

class KeyeventWindowCallback(
    val delegate: Window.Callback,
    val consumeEvents: Boolean,
    val onKeyEvent: (KeyEvent) -> Unit
) : Window.Callback by delegate {
    override fun dispatchKeyEvent(event: KeyEvent): Boolean {
        onKeyEvent(event)
        if (consumeEvents) {
            return true
        }
        return delegate.dispatchKeyEvent(event)
    }
}

class ExpoKeyeventModule : Module() {
  private var isListening = false
  private var originalCallback: Window.Callback? = null

  override fun definition() = ModuleDefinition {
    Name("ExpoKeyevent")

    Events("onKeyDown", "onKeyUp")
    Function("startListening") { consumeEvents: Boolean? ->
      if (!isListening) {
        val activity = appContext.currentActivity
        if (activity != null) {
          val window = activity.window
          val currentCallback = window.callback
          if (currentCallback !is KeyeventWindowCallback) {
            originalCallback = currentCallback
            window.callback = KeyeventWindowCallback(currentCallback, consumeEvents ?: false) { event ->
              val type = if (event.action == KeyEvent.ACTION_DOWN) "onKeyDown" else "onKeyUp"
              val keyChar = event.unicodeChar
              val keyStr = if (keyChar != 0) keyChar.toChar().toString() else KeyEvent.keyCodeToString(event.keyCode)
              
              sendEvent(type, mapOf(
                "key" to keyStr,
                "keyCode" to event.keyCode,
                "modifierFlags" to event.metaState
              ))
            }
            isListening = true
          }
        }
      }
    }
    
    Function("stopListening") {
      if (isListening) {
        val activity = appContext.currentActivity
        if (activity != null) {
          originalCallback?.let {
            activity.window.callback = it
          }
          originalCallback = null
          isListening = false
        }
      }
    }


    OnDestroy {
        val activity = appContext.currentActivity ?: return@OnDestroy
        originalCallback?.let {
            activity.window.callback = it
        }
        originalCallback = null
    }
  }
}
