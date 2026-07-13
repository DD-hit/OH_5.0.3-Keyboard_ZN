/**
 * KeyboardController manages the input method panel, text input,
 * keyboard state, and communication between the service and UI.
 */
import { display } from '@kit.ArkUI';
import { inputMethodEngine, InputMethodExtensionContext } from '@kit.IMEKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { PinyinEngine } from './PinyinEngine';
import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG = 'KeyboardController';
const inputMethodAbility: inputMethodEngine.InputMethodAbility = inputMethodEngine.getInputMethodAbility();

export class KeyboardController {
  private mContext: InputMethodExtensionContext | undefined = undefined;
  public panel: inputMethodEngine.Panel | undefined = undefined;
  private panelCreating: boolean = false;
  private textInputClient: inputMethodEngine.InputClient | undefined = undefined;

  public keyboardMode: number = 0; // 0=chinese_lower, 1=english_lower, 2=number
  public isUpper: boolean = false;
  public pinyinBuffer: string = '';
  public candidates: string[] = [];
  public allCandidates: string[] = [];
  public isCandidatePanelExpanded: boolean = false;

  // UI callbacks
  public onCandidatesUpdate?: (pinyin: string, candidates: string[], selectedIndex: number) => void;
  public onModeChange?: (mode: number) => void;
  public onCandidatePanelStateChange?: (allCandidates: string[], isExpanded: boolean) => void;

  private notifyCandidatesUpdate(): void {
    if (this.onCandidatesUpdate) {
      this.onCandidatesUpdate(this.pinyinBuffer, this.candidates, 0);
    }
  }

  private notifyModeChange(): void {
    if (this.onModeChange) {
      this.onModeChange(this.keyboardMode);
    }
  }

  private static instance: KeyboardController;

  static getInstance(): KeyboardController {
    if (!KeyboardController.instance) {
      KeyboardController.instance = new KeyboardController();
    }
    return KeyboardController.instance;
  }

  /**
   * Initialize context and window.
   */
  public onCreate(context: InputMethodExtensionContext): void {
    this.mContext = context;
    hilog.info(0x0000, TAG, 'kikaInput-js: onCreate start');
    this.initWindow();
    this.registerListener();
    hilog.info(0x0000, TAG, 'kikaInput-js: onCreate done');
  }

  /**
   * Clean up resources.
   */
  public onDestroy(): void {
    this.unRegisterListener();
    if (this.panel) {
      inputMethodAbility.destroyPanel(this.panel);
      this.panel = undefined;
    }
    if (this.mContext) {
      this.mContext.destroy();
      this.mContext = undefined;
    }
  }

  /**
   * Insert text into the attached input field.
   */
  public insertText(text: string): void {
    if (this.textInputClient) {
      try {
        this.textInputClient.insertText(text);
      } catch (err) {
        hilog.error(0x0000, TAG, 'insertText error: %{public}s', JSON.stringify(err));
      }
    }
  }

  /**
   * Delete forward (backspace) from input field.
   */
  public deleteForward(length: number): void {
    if (this.textInputClient) {
      try {
        this.textInputClient.deleteForward(length);
      } catch (err) {
        hilog.error(0x0000, TAG, 'deleteForward error: %{public}s', JSON.stringify(err));
      }
    }
  }

  /**
   * Update pinyin composition buffer.
   */
  public appendToComposition(char: string): void {
    this.pinyinBuffer += char;
    this.updateCandidates();
  }

  /**
   * Delete last character from composition.
   */
  public deleteFromComposition(): void {
    if (this.pinyinBuffer.length > 0) {
      this.pinyinBuffer = this.pinyinBuffer.slice(0, -1);
      this.updateCandidates();
    } else {
      this.deleteForward(1);
    }
  }

  /**
   * Update candidate list based on current pinyin buffer.
   */
  public updateCandidates(): void {
    if (this.pinyinBuffer.length > 0) {
      this.candidates = PinyinEngine.getCandidates(this.pinyinBuffer);
      this.allCandidates = PinyinEngine.getAllCandidates(this.pinyinBuffer);
    } else {
      this.candidates = [];
      this.allCandidates = [];
    }
    // Dismiss dropdown when candidates change
    this.isCandidatePanelExpanded = false;
    this.notifyCandidatesUpdate();
    // Sync allCandidates to UI
    if (this.onCandidatePanelStateChange) {
      this.onCandidatePanelStateChange(this.allCandidates, this.isCandidatePanelExpanded);
    }
  }

  /**
   * Toggle the candidate dropdown panel. Dismisses if already open.
   */
  public toggleCandidateDropdown(): void {
    this.isCandidatePanelExpanded = !this.isCandidatePanelExpanded;
    if (this.onCandidatePanelStateChange) {
      this.onCandidatePanelStateChange(this.allCandidates, this.isCandidatePanelExpanded);
    }
  }

  /**
   * Select a candidate character and commit it.
   */
  public selectCandidate(candidate: string): void {
    this.insertText(candidate);
    this.pinyinBuffer = '';
    this.candidates = [];
    this.allCandidates = [];
    this.isCandidatePanelExpanded = false;
    this.notifyCandidatesUpdate();
  }

  /**
   * Handle character key press in Chinese mode.
   */
  public handleChineseInput(char: string): void {
    this.appendToComposition(char);
  }

  /**
   * Handle character key press in English mode.
   */
  public handleEnglishInput(char: string): void {
    if (this.pinyinBuffer.length > 0) {
      this.insertText(this.pinyinBuffer);
      this.pinyinBuffer = '';
      this.candidates = [];
      this.allCandidates = [];
      this.isCandidatePanelExpanded = false;
      this.notifyCandidatesUpdate();
    }
    this.insertText(char);
  }

  /**
   * Toggle shift state.
   */
  public toggleShift(): void {
    this.isUpper = !this.isUpper;
  }

  // ── UI bridge methods ───────────────────────────────────

  /**
   * Unified key press handler called from keyboard UI.
   */
  public onChar(char: string): void {
    if (this.keyboardMode === 0) {
      this.handleChineseInput(char);
    } else {
      this.handleEnglishInput(char);
    }
  }

  /**
   * Delete / backspace handler.
   */
  public onDelete(): void {
    if (this.keyboardMode === 0 && this.pinyinBuffer.length > 0) {
      this.deleteFromComposition();
    } else {
      this.deleteForward(1);
    }
    this.notifyCandidatesUpdate();
  }

  /**
   * Enter key handler.
   */
  public onEnter(): void {
    if (this.pinyinBuffer.length > 0) {
      this.insertText(this.pinyinBuffer);
      this.pinyinBuffer = '';
      this.candidates = [];
      this.allCandidates = [];
      this.isCandidatePanelExpanded = false;
    }
    this.insertText('\n');
    this.notifyCandidatesUpdate();
  }

  /**
   * Shift key handler.
   */
  public onShift(): void {
    this.toggleShift();
    this.notifyModeChange();
  }

  /**
   * Switch language key handler.
   */
  public onSwitchLanguage(): void {
    this.switchLanguage();
    this.notifyModeChange();
    this.notifyCandidatesUpdate();
  }

  /**
   * Number/symbol mode toggle handler.
   */
  public onNumberSwitch(): void {
    this.switchToNumbers();
    this.notifyModeChange();
  }

  /**
   * Hide the keyboard panel.
   */
  public hideKeyboard(): void {
    try {
      if (this.panel) {
        this.panel.hide();
      }
    } catch (err) {
      hilog.error(0x0000, TAG, 'hideKeyboard error');
    }
  }

  /**
   * Toggle between Chinese, English, and Number modes.
   */
  public switchLanguage(): void {
    this.keyboardMode = (this.keyboardMode + 1) % 3;
    this.isUpper = false;
    // Commit any pending pinyin when switching away from Chinese
    if (this.pinyinBuffer.length > 0) {
      this.insertText(this.pinyinBuffer);
      this.pinyinBuffer = '';
      this.candidates = [];
      this.allCandidates = [];
      this.isCandidatePanelExpanded = false;
    }
  }

  /**
   * Switch to number/symbol layout or back.
   */
  public switchToNumbers(): void {
    if (this.keyboardMode === 2) {
      this.keyboardMode = 0;
    } else {
      this.keyboardMode = 2;
    }
  }

  /**
   * Reset all input state - commits pending pinyin.
   */
  public resetState(): void {
    if (this.pinyinBuffer.length > 0) {
      this.insertText(this.pinyinBuffer);
    }
    this.pinyinBuffer = '';
    this.candidates = [];
    this.allCandidates = [];
    this.isCandidatePanelExpanded = false;
    this.isUpper = false;
  }

  /**
   * Initialize the keyboard window/panel.
   */
  private initWindow(): void {
    if (this.mContext === undefined) {
      return;
    }

    this.panelCreating = true;
    try {
      let dis = display.getDefaultDisplaySync();
      let dWidth = dis.width;
      let dHeight = dis.height;
      let keyHeightRate = 0.40;
      let keyHeight = dHeight * keyHeightRate;
      let nonBarPosition = dHeight - keyHeight;

      let panelInfo: inputMethodEngine.PanelInfo = {
        type: inputMethodEngine.PanelType.SOFT_KEYBOARD,
        flag: inputMethodEngine.PanelFlag.FLG_FIXED
      };

      inputMethodAbility.createPanel(this.mContext, panelInfo).then(async (inputPanel: inputMethodEngine.Panel) => {
        this.panel = inputPanel;
        if (this.panel) {
          await this.panel.resize(dWidth, keyHeight);
          await this.panel.moveTo(0, nonBarPosition);
          await this.panel.setUiContent('inputmethodext/pages/KeyboardPage');
        }
        this.panelCreating = false;
      }).catch((err: BusinessError) => {
        hilog.error(0x0000, TAG, 'createPanel failed: %{public}s', JSON.stringify(err));
        this.panelCreating = false;
      });
    } catch (err) {
      hilog.error(0x0000, TAG, 'initWindow error: %{public}s', JSON.stringify(err));
      this.panelCreating = false;
    }
  }

  /**
   * Register IME event listeners.
   */
  private registerListener(): void {
    this.registerInputListener();
  }

  private inputStartCallback?: (kbController: inputMethodEngine.KeyboardController,
    textInputClient: inputMethodEngine.InputClient) => void;
  private inputStopCallback?: () => void;

  /**
   * Register input start/stop event listeners.
   */
  private registerInputListener(): void {
    this.inputStartCallback = (kbController: inputMethodEngine.KeyboardController,
      textInputClient: inputMethodEngine.InputClient) => {
      hilog.info(0x0000, TAG, 'kikaInput-js: inputStart received');
      this.textInputClient = textInputClient;
      // Retry panel creation if it failed during onCreate (e.g., JS bundle not ready).
      if (!this.panel && !this.panelCreating) {
        hilog.info(0x0000, TAG, 'kikaInput-js: panel not ready, retrying initWindow');
        this.initWindow();
      }
    };
    inputMethodAbility.on('inputStart', this.inputStartCallback);

    this.inputStopCallback = () => {
      hilog.info(0x0000, TAG, 'kikaInput-js: inputStop received, resetting state');
      // Only clear the current input session - do NOT destroy the panel or context.
      this.textInputClient = undefined;
      this.resetState();
    };
    inputMethodAbility.on('inputStop', this.inputStopCallback);
  }

  /**
   * Unregister all listeners.
   */
  private unRegisterListener(): void {
    if (this.inputStartCallback) {
      inputMethodAbility.off('inputStart', this.inputStartCallback);
      this.inputStartCallback = undefined;
    }
    if (this.inputStopCallback) {
      inputMethodAbility.off('inputStop', this.inputStopCallback);
      this.inputStopCallback = undefined;
    }
  }
}
