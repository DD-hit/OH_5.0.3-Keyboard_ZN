/**
 * InputMethodService - The main InputMethodExtensionAbility implementation.
 * Handles system lifecycle callbacks and delegates to KeyboardController.
 */
import { InputMethodExtensionAbility } from '@kit.IMEKit';
import { InputMethodExtensionContext } from '@kit.IMEKit';
import { KeyboardController } from './model/KeyboardController';
import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG = 'InputMethodService';

export default class InputMethodService extends InputMethodExtensionAbility {
  private keyboardController: KeyboardController = KeyboardController.getInstance();

  onCreate(): void {
    hilog.info(0x0000, TAG, 'onCreate');
    try {
      let context: InputMethodExtensionContext = this.context as InputMethodExtensionContext;
      this.keyboardController.onCreate(context);
    } catch (err) {
      hilog.error(0x0000, TAG, 'onCreate error: %{public}s', JSON.stringify(err));
    }
  }

  onDestroy(): void {
    hilog.info(0x0000, TAG, 'onDestroy');
    this.keyboardController.onDestroy();
  }
}
