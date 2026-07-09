/**
 * Keyboard key types and data structures for layout definition.
 */

export enum KeyType {
  CHARACTER,   // Regular character key
  SHIFT,       // Shift toggle
  DELETE,      // Backspace/delete
  ENTER,       // Enter/return key
  SPACE,       // Space bar
  SWITCH_LANG, // Switch between Chinese/English
  SYMBOL,      // Toggle to symbol layout
  NUMBER,      // Toggle to number layout
  CANDIDATE,   // Candidate selection
  CLOSE,       // Close/hide keyboard
}

export enum KeyboardMode {
  CHINESE_LOWER,   // Chinese pinyin layout (lowercase)
  CHINESE_UPPER,   // Chinese pinyin layout (uppercase)
  ENGLISH_LOWER,   // English layout (lowercase)
  ENGLISH_UPPER,   // English layout (uppercase)
  NUMBER,          // Number & symbol layout
  SYMBOL,          // Extended symbol layout
}

export interface KeyData {
  type: KeyType;
  label: string;        // Display label
  code: string;         // The actual character/code to output
  width: number;        // Relative width (1 = normal, 1.5 = wider, etc.)
  altCode: string;      // Alternative output when shifted
}

export interface KeyRow {
  keys: KeyData[];
}

export const PUNCTUATION_MARKS: string[] = [
  '，', '。', '！', '？', '、', '；', '：',
  '“', '”', '（', '）', '《', '》', '…',
  '—', '～', '·', '【', '】',
];
