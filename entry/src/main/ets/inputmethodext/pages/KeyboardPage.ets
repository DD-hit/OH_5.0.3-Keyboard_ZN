/**
 * KeyboardPage - Professional input method keyboard UI.
 * iOS-style layout: candidate bar on top, key rows filling the panel below.
 */
import { KeyboardController } from '../model/KeyboardController';
import { KeyType } from './KeyboardKeyData';

// ─── Design Tokens ──────────────────────────────────────
const BG_COLOR = '#D1D3D9';
const KEY_BG = '#FFFFFF';
const FUNC_KEY_BG = '#AEB3BE';
const KEY_TEXT = '#000000';
const CANDIDATE_ROW_H = 40;
const KEY_H = 44;
const ROW_GAP = 6;
const KEY_GAP = 5;
const KEY_RADIUS = 5;
const DROPDOWN_CANDIDATE_H = 42;
const DROPDOWN_BG = '#F0F0F5';
const DROPDOWN_CANDIDATE_BG = '#FFFFFF';

// ─── Key Definition ─────────────────────────────────────
interface KeyDef {
  label: string;
  type: KeyType;
  weight: number;
}

function mkKey(label: string, type: KeyType, weight: number = 1): KeyDef {
  return { label, type, weight };
}

// ─── Layout Definitions ─────────────────────────────────
interface LayoutDef {
  label: string;
  keys: KeyDef[][];
}

const CHINESE_LOWER_LAYOUT: LayoutDef = {
  label: '拼音',
  keys: [
    [
      mkKey('q', KeyType.CHARACTER), mkKey('w', KeyType.CHARACTER),
      mkKey('e', KeyType.CHARACTER), mkKey('r', KeyType.CHARACTER),
      mkKey('t', KeyType.CHARACTER), mkKey('y', KeyType.CHARACTER),
      mkKey('u', KeyType.CHARACTER), mkKey('i', KeyType.CHARACTER),
      mkKey('o', KeyType.CHARACTER), mkKey('p', KeyType.CHARACTER),
    ],
    [
      mkKey('a', KeyType.CHARACTER), mkKey('s', KeyType.CHARACTER),
      mkKey('d', KeyType.CHARACTER), mkKey('f', KeyType.CHARACTER),
      mkKey('g', KeyType.CHARACTER), mkKey('h', KeyType.CHARACTER),
      mkKey('j', KeyType.CHARACTER), mkKey('k', KeyType.CHARACTER),
      mkKey('l', KeyType.CHARACTER),
    ],
    [
      mkKey('⇧', KeyType.SHIFT, 1.5),
      mkKey('z', KeyType.CHARACTER), mkKey('x', KeyType.CHARACTER),
      mkKey('c', KeyType.CHARACTER), mkKey('v', KeyType.CHARACTER),
      mkKey('b', KeyType.CHARACTER), mkKey('n', KeyType.CHARACTER),
      mkKey('m', KeyType.CHARACTER),
      mkKey('⌫', KeyType.DELETE, 1.5),
    ],
    [
      mkKey('符', KeyType.NUMBER, 1.2),
      mkKey('中/英', KeyType.SWITCH_LANG, 1.2),
      mkKey(' ', KeyType.SPACE, 5),
      mkKey('。', KeyType.CHARACTER, 1.2),
      mkKey('↵', KeyType.ENTER, 1.5),
    ],
  ],
};

const ENGLISH_LOWER_LAYOUT: LayoutDef = {
  label: '英文',
  keys: [
    [
      mkKey('q', KeyType.CHARACTER), mkKey('w', KeyType.CHARACTER),
      mkKey('e', KeyType.CHARACTER), mkKey('r', KeyType.CHARACTER),
      mkKey('t', KeyType.CHARACTER), mkKey('y', KeyType.CHARACTER),
      mkKey('u', KeyType.CHARACTER), mkKey('i', KeyType.CHARACTER),
      mkKey('o', KeyType.CHARACTER), mkKey('p', KeyType.CHARACTER),
    ],
    [
      mkKey('a', KeyType.CHARACTER), mkKey('s', KeyType.CHARACTER),
      mkKey('d', KeyType.CHARACTER), mkKey('f', KeyType.CHARACTER),
      mkKey('g', KeyType.CHARACTER), mkKey('h', KeyType.CHARACTER),
      mkKey('j', KeyType.CHARACTER), mkKey('k', KeyType.CHARACTER),
      mkKey('l', KeyType.CHARACTER),
    ],
    [
      mkKey('⇧', KeyType.SHIFT, 1.5),
      mkKey('z', KeyType.CHARACTER), mkKey('x', KeyType.CHARACTER),
      mkKey('c', KeyType.CHARACTER), mkKey('v', KeyType.CHARACTER),
      mkKey('b', KeyType.CHARACTER), mkKey('n', KeyType.CHARACTER),
      mkKey('m', KeyType.CHARACTER),
      mkKey('⌫', KeyType.DELETE, 1.5),
    ],
    [
      mkKey('123', KeyType.NUMBER, 1.2),
      mkKey('中/英', KeyType.SWITCH_LANG, 1.2),
      mkKey(' ', KeyType.SPACE, 5),
      mkKey('.', KeyType.CHARACTER, 1.2),
      mkKey('↵', KeyType.ENTER, 1.5),
    ],
  ],
};

const NUMBER_LAYOUT: KeyDef[][] = [
  [
    mkKey('1', KeyType.CHARACTER), mkKey('2', KeyType.CHARACTER),
    mkKey('3', KeyType.CHARACTER), mkKey('4', KeyType.CHARACTER),
    mkKey('5', KeyType.CHARACTER), mkKey('6', KeyType.CHARACTER),
    mkKey('7', KeyType.CHARACTER), mkKey('8', KeyType.CHARACTER),
    mkKey('9', KeyType.CHARACTER), mkKey('0', KeyType.CHARACTER),
  ],
  [
    mkKey('-', KeyType.CHARACTER), mkKey('/', KeyType.CHARACTER),
    mkKey(':', KeyType.CHARACTER), mkKey(';', KeyType.CHARACTER),
    mkKey('(', KeyType.CHARACTER), mkKey(')', KeyType.CHARACTER),
    mkKey('¥', KeyType.CHARACTER), mkKey('&', KeyType.CHARACTER),
    mkKey('@', KeyType.CHARACTER), mkKey('"', KeyType.CHARACTER),
  ],
  [
    mkKey('#+=', KeyType.SYMBOL, 1.2),
    mkKey('。', KeyType.CHARACTER), mkKey('，', KeyType.CHARACTER),
    mkKey('、', KeyType.CHARACTER), mkKey('！', KeyType.CHARACTER),
    mkKey('？', KeyType.CHARACTER),
    mkKey('⌫', KeyType.DELETE, 1.5),
  ],
  [
    mkKey('ABC', KeyType.SWITCH_LANG, 1.2),
    mkKey(',', KeyType.CHARACTER, 1.2),
    mkKey(' ', KeyType.SPACE, 5),
    mkKey('.', KeyType.CHARACTER, 1.2),
    mkKey('↵', KeyType.ENTER, 1.5),
  ],
];

// ─── Component ──────────────────────────────────────────
@Entry
@Component
export struct KeyboardPage {
  @Prop keyboardController: KeyboardController = KeyboardController.getInstance();

  @State pinyinBuffer: string = '';
  @State candidates: string[] = [];
  @State selectedIndex: number = 0;
  @State keyboardMode: number = 0;
  @State isUpper: boolean = false;
  // Dropdown panel state
  @State allCandidates: string[] = [];
  @State showCandidateDropdown: boolean = false;

  aboutToAppear(): void {
    this.keyboardMode = this.keyboardController.keyboardMode;
    this.isUpper = this.keyboardController.isUpper;
    this.keyboardController.onCandidatesUpdate = (pinyin: string, cands: string[], idx: number) => {
      this.pinyinBuffer = pinyin;
      this.candidates = cands;
      this.selectedIndex = idx;
    };
    this.keyboardController.onModeChange = (mode: number) => {
      this.keyboardMode = mode;
      this.isUpper = false;
    };
    this.keyboardController.onCandidatePanelStateChange = (allCands: string[], expanded: boolean) => {
      this.allCandidates = allCands;
      this.showCandidateDropdown = expanded;
    };
  }

  aboutToDisappear(): void {
    this.keyboardController.onCandidatesUpdate = undefined;
    this.keyboardController.onModeChange = undefined;
    this.keyboardController.onCandidatePanelStateChange = undefined;
  }

  // ─── Build ────────────────────────────────────────────
  build() {
    Stack() {
      Column() {
        this.CandidateBar()
        this.KeyRows()
      }
      .width('100%')
      .height('100%')
      .backgroundColor(BG_COLOR)

      // Dropdown overlay for extra candidates
      if (this.showCandidateDropdown) {
        this.CandidateDropdownPanel()
      }
    }
    .width('100%')
    .height('100%')
  }

  // ─── Candidate Bar ────────────────────────────────────
  @Builder
  CandidateBar() {
    Row() {
      if (this.pinyinBuffer.length > 0) {
        Row() {
          Text(this.pinyinBuffer)
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .fontColor('#007AFF')
        }
        .padding({ left: 8, right: 6 })

        Divider()
          .vertical(true)
          .height(20)
          .color('#D1D3D9')
          .margin({ right: 4 })
      } else {
        Text(this.getLayoutLabel())
          .fontSize(12)
          .fontColor('#8E8E93')
          .padding({ left: 8, right: 6 })
      }

      Scroll() {
        Row({ space: 4 }) {
          ForEach(this.candidates, (candidate: string, index: number) => {
            Text(candidate)
              .fontSize(17)
              .fontColor(index === this.selectedIndex ? '#007AFF' : '#1A1A1A')
              .fontWeight(index === this.selectedIndex ? FontWeight.Bold : FontWeight.Normal)
              .padding({ left: 6, right: 6, top: 4, bottom: 4 })
              .borderRadius(4)
              .backgroundColor(index === this.selectedIndex ? '#E8F0FE' : Color.Transparent)
              .onClick(() => this.onSelectCandidate(candidate))
          })
        }
        .padding({ left: 2, right: 2 })
      }
      .scrollable(ScrollDirection.Horizontal)
      .scrollBar(BarState.Off)
      .layoutWeight(1)
      .align(Alignment.Start)

      // Expand button for more candidates
      if (this.allCandidates.length > this.candidates.length) {
        Divider()
          .vertical(true)
          .height(20)
          .color('#D1D3D9')
          .margin({ left: 4, right: 4 })

        Text(this.showCandidateDropdown ? '▲' : '▼')
          .fontSize(11)
          .fontColor('#8E8E93')
          .padding({ left: 4, right: 8, top: 2, bottom: 4 })
          .onClick(() => this.onToggleDropdown())
      }
    }
    .width('100%')
    .height(CANDIDATE_ROW_H)
    .backgroundColor('#F8F8FA')
    .borderRadius({ topLeft: 6, topRight: 6 })
    .padding({ left: 4, right: 4, top: 6 })
  }

  // ─── Candidate Dropdown Panel ─────────────────────────
  @Builder
  CandidateDropdownPanel() {
    Column() {
      // Grid of all candidates
      Scroll() {
        Flex({ wrap: FlexWrap.Wrap, alignItems: ItemAlign.Center }) {
          ForEach(this.allCandidates, (candidate: string) => {
            Text(candidate)
              .fontSize(17)
              .fontColor('#1A1A1A')
              .height(DROPDOWN_CANDIDATE_H)
              .padding({ left: 10, right: 10 })
              .borderRadius(4)
              .backgroundColor(DROPDOWN_CANDIDATE_BG)
              .textAlign(TextAlign.Center)
              .margin(4)
              .onClick(() => this.onSelectDropdownCandidate(candidate))
          })
        }
        .padding(8)
        .width('100%')
      }
      .scrollable(ScrollDirection.Vertical)
      .scrollBar(BarState.Off)
    }
    .width('100%')
    .height('100%')
    .backgroundColor(DROPDOWN_BG)
  }

  // ─── Key Rows ─────────────────────────────────────────
  @Builder
  KeyRows() {
    Column({ space: ROW_GAP }) {
      if (this.keyboardMode === 2) {
        ForEach(NUMBER_LAYOUT, (row: KeyDef[]) => {
          this.KeyRow(row, false)
        })
      } else {
        this.AlphaKeyRows()
      }
    }
    .width('100%')
    .layoutWeight(1)
    .justifyContent(FlexAlign.Center)
    .padding({ left: 3, right: 3, bottom: 6 })
  }

  @Builder
  AlphaKeyRows() {
    this.KeyRow(this.getAlphaLayout().keys[0], false)
    this.KeyRow(this.getAlphaLayout().keys[1], true)
    this.KeyRow(this.getAlphaLayout().keys[2], false)
    this.KeyRow(this.getAlphaLayout().keys[3], false)
  }

  // ─── Single Key Row ───────────────────────────────────
  @Builder
  KeyRow(keys: KeyDef[], indent: boolean) {
    Row({ space: KEY_GAP }) {
      ForEach(keys, (key: KeyDef) => {
        this.KeyButton(key)
      })
    }
    .width('100%')
    .padding({ left: indent ? '4.5%' : 0, right: indent ? '4.5%' : 0 })
  }

  // ─── Key Button ───────────────────────────────────────
  @Builder
  KeyButton(key: KeyDef) {
    Text(key.label)
      .width('100%')
      .height(KEY_H)
      .fontSize(this.getKeyFontSize(key.label))
      .fontColor(KEY_TEXT)
      .fontWeight(FontWeight.Medium)
      .textAlign(TextAlign.Center)
      .backgroundColor(key.type === KeyType.CHARACTER || key.type === KeyType.SPACE ? KEY_BG : FUNC_KEY_BG)
      .borderRadius(KEY_RADIUS)
      .shadow({ radius: 1, color: '#00000020', offsetX: 0, offsetY: 1 })
      .layoutWeight(key.weight)
      .onClick(() => this.onKeyPress(key))
  }

  // ─── Helpers ──────────────────────────────────────────
  private getLayoutLabel(): string {
    if (this.keyboardMode === 0) {
      return '拼音';
    }
    if (this.keyboardMode === 1) {
      return '英文';
    }
    return '123';
  }

  private getAlphaLayout(): LayoutDef {
    return this.keyboardMode === 0 ? CHINESE_LOWER_LAYOUT : ENGLISH_LOWER_LAYOUT;
  }

  private getKeyFontSize(label: string): number {
    if (label.length > 2) {
      return 13;
    }
    if (label === '⇧' || label === '⌫') {
      return 16;
    }
    return 18;
  }

  // ─── Events ───────────────────────────────────────────
  private onKeyPress(key: KeyDef): void {
    switch (key.type) {
      case KeyType.CHARACTER:
        this.keyboardController.onChar(key.label);
        break;
      case KeyType.DELETE:
        this.keyboardController.onDelete();
        break;
      case KeyType.ENTER:
        this.keyboardController.onEnter();
        break;
      case KeyType.SPACE:
        this.keyboardController.onChar(' ');
        break;
      case KeyType.SHIFT:
        this.keyboardController.onShift();
        break;
      case KeyType.SWITCH_LANG:
        this.keyboardController.onSwitchLanguage();
        break;
      case KeyType.NUMBER:
        this.keyboardController.onNumberSwitch();
        break;
      case KeyType.SYMBOL:
        this.keyboardController.onNumberSwitch();
        break;
    }
  }

  private onSelectCandidate(candidate: string): void {
    this.keyboardController.selectCandidate(candidate);
    this.pinyinBuffer = '';
    this.candidates = [];
    this.allCandidates = [];
    this.showCandidateDropdown = false;
    this.selectedIndex = 0;
  }

  private onSelectDropdownCandidate(candidate: string): void {
    this.keyboardController.selectCandidate(candidate);
    this.pinyinBuffer = '';
    this.candidates = [];
    this.allCandidates = [];
    this.showCandidateDropdown = false;
    this.selectedIndex = 0;
  }

  private onToggleDropdown(): void {
    this.keyboardController.toggleCandidateDropdown();
  }

  private onHideKeyboard(): void {
    this.keyboardController.hideKeyboard();
  }
}
