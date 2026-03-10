import '../../domain/entities/sticker_entity.dart';

// ---------------------------------------------------------------------------
// Inline SVG strings — no asset files required
// ---------------------------------------------------------------------------

// ── AMOR / RELACIONAMENTO ──────────────────────────────────────────────────
const _heart = '''<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
  <path d="M50 82 C12 58 8 22 28 14 C38 9 47 15 50 26 C53 15 62 9 72 14 C92 22 88 58 50 82Z" fill="#FF4D7C"/>
</svg>''';

const _heartOutline = '''<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
  <path d="M50 82 C12 58 8 22 28 14 C38 9 47 15 50 26 C53 15 62 9 72 14 C92 22 88 58 50 82Z" fill="none" stroke="#FF4D7C" stroke-width="5"/>
</svg>''';

const _heartBroken = '''<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
  <path d="M50 82 C12 58 8 22 28 14 C38 9 47 15 50 26 C53 15 62 9 72 14 C92 22 88 58 50 82Z" fill="#FF4D7C"/>
  <path d="M50 26 L44 46 L52 46 L46 68" stroke="white" stroke-width="3" fill="none" stroke-linecap="round"/>
</svg>''';

const _infinity = '''<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
  <path d="M50 50 C50 50 35 25 18 25 C8 25 2 33 2 50 C2 67 8 75 18 75 C35 75 50 50 50 50 C50 50 65 25 82 25 C92 25 98 33 98 50 C98 67 92 75 82 75 C65 75 50 50 50 50Z"
    fill="none" stroke="#9B59B6" stroke-width="10" stroke-linecap="round"/>
</svg>''';

const _ribbon = '''<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
  <path d="M50 50 L18 22 C14 16 22 8 28 14 L50 38 L72 14 C78 8 86 16 82 22Z" fill="#FF69B4"/>
  <path d="M50 50 L18 78 C14 84 22 92 28 86 L50 62 L72 86 C78 92 86 84 82 78Z" fill="#FF1493"/>
  <circle cx="50" cy="50" r="8" fill="#FFD700"/>
</svg>''';

// ── NATUREZA / CLIMA ───────────────────────────────────────────────────────
const _sun = '''<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
  <circle cx="50" cy="50" r="22" fill="#FFD700"/>
  <line x1="50" y1="5" x2="50" y2="20" stroke="#FFD700" stroke-width="6" stroke-linecap="round"/>
  <line x1="50" y1="80" x2="50" y2="95" stroke="#FFD700" stroke-width="6" stroke-linecap="round"/>
  <line x1="5" y1="50" x2="20" y2="50" stroke="#FFD700" stroke-width="6" stroke-linecap="round"/>
  <line x1="80" y1="50" x2="95" y2="50" stroke="#FFD700" stroke-width="6" stroke-linecap="round"/>
  <line x1="18" y1="18" x2="29" y2="29" stroke="#FFD700" stroke-width="5" stroke-linecap="round"/>
  <line x1="71" y1="71" x2="82" y2="82" stroke="#FFD700" stroke-width="5" stroke-linecap="round"/>
  <line x1="82" y1="18" x2="71" y2="29" stroke="#FFD700" stroke-width="5" stroke-linecap="round"/>
  <line x1="29" y1="71" x2="18" y2="82" stroke="#FFD700" stroke-width="5" stroke-linecap="round"/>
</svg>''';

const _moon = '''<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
  <path d="M62 18 A32 32 0 1 0 62 82 A22 22 0 1 1 62 18Z" fill="#C8D8FF"/>
</svg>''';

const _rainbow = '''<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
  <path d="M5 70 A45 45 0 0 1 95 70" fill="none" stroke="#FF0000" stroke-width="6" stroke-linecap="round"/>
  <path d="M10 70 A40 40 0 0 1 90 70" fill="none" stroke="#FF7F00" stroke-width="6" stroke-linecap="round"/>
  <path d="M15 70 A35 35 0 0 1 85 70" fill="none" stroke="#FFFF00" stroke-width="6" stroke-linecap="round"/>
  <path d="M20 70 A30 30 0 0 1 80 70" fill="none" stroke="#00CC00" stroke-width="6" stroke-linecap="round"/>
  <path d="M25 70 A25 25 0 0 1 75 70" fill="none" stroke="#0000FF" stroke-width="6" stroke-linecap="round"/>
  <path d="M30 70 A20 20 0 0 1 70 70" fill="none" stroke="#8B00FF" stroke-width="6" stroke-linecap="round"/>
  <ellipse cx="12" cy="75" rx="12" ry="10" fill="white" opacity="0.9"/>
  <ellipse cx="88" cy="75" rx="12" ry="10" fill="white" opacity="0.9"/>
</svg>''';

const _cloud = '''<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
  <circle cx="35" cy="55" r="22" fill="#E8E8E8"/>
  <circle cx="55" cy="48" r="26" fill="#E8E8E8"/>
  <circle cx="72" cy="57" r="18" fill="#E8E8E8"/>
  <rect x="18" y="55" width="70" height="22" rx="5" fill="#E8E8E8"/>
</svg>''';

const _cloudRain = '''<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
  <circle cx="35" cy="42" r="18" fill="#B0BEC5"/>
  <circle cx="52" cy="36" r="22" fill="#B0BEC5"/>
  <circle cx="68" cy="44" r="16" fill="#B0BEC5"/>
  <rect x="20" y="42" width="64" height="18" rx="4" fill="#B0BEC5"/>
  <line x1="30" y1="70" x2="25" y2="85" stroke="#4FC3F7" stroke-width="3" stroke-linecap="round"/>
  <line x1="45" y1="70" x2="40" y2="85" stroke="#4FC3F7" stroke-width="3" stroke-linecap="round"/>
  <line x1="60" y1="70" x2="55" y2="85" stroke="#4FC3F7" stroke-width="3" stroke-linecap="round"/>
  <line x1="75" y1="70" x2="70" y2="85" stroke="#4FC3F7" stroke-width="3" stroke-linecap="round"/>
</svg>''';

const _snowflake = '''<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
  <line x1="50" y1="8" x2="50" y2="92" stroke="#90CAF9" stroke-width="5" stroke-linecap="round"/>
  <line x1="8" y1="50" x2="92" y2="50" stroke="#90CAF9" stroke-width="5" stroke-linecap="round"/>
  <line x1="19" y1="19" x2="81" y2="81" stroke="#90CAF9" stroke-width="5" stroke-linecap="round"/>
  <line x1="81" y1="19" x2="19" y2="81" stroke="#90CAF9" stroke-width="5" stroke-linecap="round"/>
  <line x1="38" y1="8" x2="50" y2="20" stroke="#90CAF9" stroke-width="3" stroke-linecap="round"/>
  <line x1="62" y1="8" x2="50" y2="20" stroke="#90CAF9" stroke-width="3" stroke-linecap="round"/>
  <line x1="38" y1="92" x2="50" y2="80" stroke="#90CAF9" stroke-width="3" stroke-linecap="round"/>
  <line x1="62" y1="92" x2="50" y2="80" stroke="#90CAF9" stroke-width="3" stroke-linecap="round"/>
</svg>''';

const _lightning = '''<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
  <polygon points="60,5 25,52 48,52 40,95 75,48 52,48" fill="#FFE500"/>
  <polygon points="60,5 25,52 48,52 40,95 75,48 52,48" fill="none" stroke="#FF8C00" stroke-width="2"/>
</svg>''';

const _fire = '''<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
  <path d="M50 95 C25 95 8 78 8 58 C8 42 20 30 30 22 C28 34 35 40 42 36 C35 26 40 10 50 5 C48 18 56 25 60 20 C68 10 65 28 58 35 C66 30 72 38 70 48 C78 42 80 28 76 18 C88 28 92 44 92 58 C92 78 75 95 50 95Z" fill="#FF5722"/>
  <path d="M50 85 C35 85 22 74 22 60 C22 50 30 43 38 38 C36 46 41 51 46 48 C42 40 46 30 52 26 C50 35 55 40 59 36 C64 30 62 42 56 46 C62 42 66 50 64 58 C68 54 70 44 68 36 C75 44 78 56 78 60 C78 74 65 85 50 85Z" fill="#FF9800"/>
  <path d="M50 75 C42 75 36 70 36 62 C36 56 42 52 46 50 C46 55 50 58 52 55 C55 60 52 68 50 75Z" fill="#FFEB3B"/>
</svg>''';

const _wave = '''<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
  <path d="M5 35 C15 20 25 50 35 35 C45 20 55 50 65 35 C75 20 85 50 95 35" fill="none" stroke="#0099FF" stroke-width="7" stroke-linecap="round"/>
  <path d="M5 55 C15 40 25 70 35 55 C45 40 55 70 65 55 C75 40 85 70 95 55" fill="none" stroke="#00CFFF" stroke-width="7" stroke-linecap="round"/>
  <path d="M5 75 C15 60 25 90 35 75 C45 60 55 90 65 75 C75 60 85 90 95 75" fill="none" stroke="#80E8FF" stroke-width="7" stroke-linecap="round"/>
</svg>''';

const _flower = '''<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
  <ellipse cx="50" cy="22" rx="10" ry="18" fill="#FF85C2"/>
  <ellipse cx="50" cy="22" rx="10" ry="18" fill="#FF85C2" transform="rotate(60 50 50)"/>
  <ellipse cx="50" cy="22" rx="10" ry="18" fill="#FF85C2" transform="rotate(120 50 50)"/>
  <ellipse cx="50" cy="22" rx="10" ry="18" fill="#FFB3D9" transform="rotate(180 50 50)"/>
  <ellipse cx="50" cy="22" rx="10" ry="18" fill="#FFB3D9" transform="rotate(240 50 50)"/>
  <ellipse cx="50" cy="22" rx="10" ry="18" fill="#FFB3D9" transform="rotate(300 50 50)"/>
  <circle cx="50" cy="50" r="14" fill="#FFD700"/>
</svg>''';

const _sunflower = '''<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
  <ellipse cx="50" cy="22" rx="8" ry="16" fill="#FFD700" transform="rotate(0 50 50)"/>
  <ellipse cx="50" cy="22" rx="8" ry="16" fill="#FFD700" transform="rotate(45 50 50)"/>
  <ellipse cx="50" cy="22" rx="8" ry="16" fill="#FFD700" transform="rotate(90 50 50)"/>
  <ellipse cx="50" cy="22" rx="8" ry="16" fill="#FFC107" transform="rotate(135 50 50)"/>
  <ellipse cx="50" cy="22" rx="8" ry="16" fill="#FFC107" transform="rotate(180 50 50)"/>
  <ellipse cx="50" cy="22" rx="8" ry="16" fill="#FFC107" transform="rotate(225 50 50)"/>
  <ellipse cx="50" cy="22" rx="8" ry="16" fill="#FFD700" transform="rotate(270 50 50)"/>
  <ellipse cx="50" cy="22" rx="8" ry="16" fill="#FFD700" transform="rotate(315 50 50)"/>
  <circle cx="50" cy="50" r="16" fill="#5D4037"/>
  <circle cx="44" cy="44" r="2" fill="#8D6E63"/>
  <circle cx="50" cy="42" r="2" fill="#8D6E63"/>
  <circle cx="56" cy="44" r="2" fill="#8D6E63"/>
  <circle cx="58" cy="50" r="2" fill="#8D6E63"/>
  <circle cx="56" cy="56" r="2" fill="#8D6E63"/>
  <circle cx="50" cy="58" r="2" fill="#8D6E63"/>
  <circle cx="44" cy="56" r="2" fill="#8D6E63"/>
  <circle cx="42" cy="50" r="2" fill="#8D6E63"/>
</svg>''';

const _leaf = '''<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
  <path d="M50 90 C50 90 10 60 15 25 C15 25 35 10 65 20 C85 28 90 55 50 90Z" fill="#4CAF50"/>
  <path d="M50 90 C50 90 10 60 15 25 C15 25 35 10 65 20 C85 28 90 55 50 90Z" fill="none" stroke="#388E3C" stroke-width="2"/>
  <path d="M50 90 C50 90 48 55 50 25" stroke="#388E3C" stroke-width="2.5" stroke-linecap="round" fill="none"/>
  <path d="M50 65 C44 55 30 50 22 44" stroke="#388E3C" stroke-width="1.5" stroke-linecap="round" fill="none"/>
  <path d="M50 50 C60 42 68 34 72 28" stroke="#388E3C" stroke-width="1.5" stroke-linecap="round" fill="none"/>
</svg>''';

const _butterfly = '''<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
  <path d="M50 50 C42 38 18 20 10 28 C4 34 8 55 25 58 C38 60 48 52 50 50Z" fill="#FF7F50"/>
  <path d="M50 50 C58 38 82 20 90 28 C96 34 92 55 75 58 C62 60 52 52 50 50Z" fill="#FF6347"/>
  <path d="M50 50 C42 62 20 78 12 72 C6 66 12 50 28 46 C40 43 49 48 50 50Z" fill="#FFA07A"/>
  <path d="M50 50 C58 62 80 78 88 72 C94 66 88 50 72 46 C60 43 51 48 50 50Z" fill="#FF8C69"/>
  <ellipse cx="50" cy="50" rx="4" ry="18" fill="#333333"/>
  <circle cx="50" cy="32" r="3" fill="#333333"/>
  <path d="M50 32 C45 24 40 18 36 14" stroke="#333333" stroke-width="1.5" fill="none" stroke-linecap="round"/>
  <path d="M50 32 C55 24 60 18 64 14" stroke="#333333" stroke-width="1.5" fill="none" stroke-linecap="round"/>
</svg>''';

// ── FORMAS GEOMÉTRICAS ─────────────────────────────────────────────────────
const _star = '''<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
  <polygon points="50,6 61,36 95,36 68,56 79,90 50,70 21,90 32,56 5,36 39,36" fill="#FFD700"/>
</svg>''';

const _starOutline = '''<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
  <polygon points="50,6 61,36 95,36 68,56 79,90 50,70 21,90 32,56 5,36 39,36" fill="none" stroke="#FFD700" stroke-width="4"/>
</svg>''';

const _sparkle = '''<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
  <path d="M50 5 L54 44 L90 50 L54 56 L50 95 L46 56 L10 50 L46 44Z" fill="#FFD700"/>
  <path d="M20 15 L22 30 L36 32 L22 34 L20 50 L18 34 L4 32 L18 30Z" fill="#FFE44D" opacity="0.8"/>
  <path d="M80 55 L82 67 L94 68 L82 70 L80 82 L78 70 L66 68 L78 67Z" fill="#FFE44D" opacity="0.8"/>
</svg>''';

const _diamond = '''<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
  <polygon points="50,5 85,38 50,95 15,38" fill="#00CFFF"/>
  <polygon points="50,5 85,38 50,38" fill="#80E8FF"/>
  <polygon points="15,38 50,38 50,95" fill="#0099CC"/>
  <polygon points="85,38 50,38 50,95" fill="#007AAA"/>
</svg>''';

const _hexagon = '''<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
  <polygon points="50,5 90,27 90,73 50,95 10,73 10,27" fill="#7C4DFF"/>
  <polygon points="50,18 78,34 78,66 50,82 22,66 22,34" fill="#B39DDB"/>
</svg>''';

const _triangle = '''<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
  <polygon points="50,8 95,88 5,88" fill="#FF6B35"/>
  <polygon points="50,25 80,80 20,80" fill="#FF9A70"/>
</svg>''';

const _circle3d = '''<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
  <circle cx="50" cy="50" r="44" fill="#E91E63"/>
  <circle cx="38" cy="36" r="18" fill="#F48FB1" opacity="0.6"/>
  <circle cx="35" cy="33" r="8" fill="white" opacity="0.4"/>
</svg>''';

const _cross = '''<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
  <rect x="38" y="8" width="24" height="84" rx="8" fill="#E53935"/>
  <rect x="8" y="38" width="84" height="24" rx="8" fill="#E53935"/>
</svg>''';

// ── SÍMBOLOS / EMBLEMAS ────────────────────────────────────────────────────
const _crown = '''<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
  <polygon points="10,75 10,35 30,55 50,15 70,55 90,35 90,75" fill="#FFD700"/>
  <rect x="10" y="72" width="80" height="12" rx="4" fill="#FFA500"/>
  <circle cx="50" cy="15" r="6" fill="#FF4444"/>
  <circle cx="10" cy="35" r="5" fill="#4444FF"/>
  <circle cx="90" cy="35" r="5" fill="#44FF44"/>
</svg>''';

const _shield = '''<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
  <path d="M50 5 L90 20 L90 55 C90 72 72 86 50 95 C28 86 10 72 10 55 L10 20Z" fill="#3498DB"/>
  <path d="M50 25 L80 36 L80 58 C80 70 66 80 50 87 C34 80 20 70 20 58 L20 36Z" fill="#5DADE2" opacity="0.5"/>
  <path d="M36 50 L45 60 L65 38" fill="none" stroke="#FFFFFF" stroke-width="7" stroke-linecap="round" stroke-linejoin="round"/>
</svg>''';

const _trophy = '''<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
  <path d="M30 10 L70 10 L68 55 C68 68 60 75 50 75 C40 75 32 68 30 55Z" fill="#FFD700"/>
  <path d="M70 18 C80 18 88 24 88 40 C88 52 80 58 72 60 L68 45 C76 44 80 40 80 35 C80 28 76 24 70 24Z" fill="#FFA500"/>
  <path d="M30 18 C20 18 12 24 12 40 C12 52 20 58 28 60 L32 45 C24 44 20 40 20 35 C20 28 24 24 30 24Z" fill="#FFA500"/>
  <rect x="40" y="75" width="20" height="10" fill="#CC8800"/>
  <rect x="32" y="85" width="36" height="8" rx="3" fill="#CC8800"/>
</svg>''';

const _badge = '''<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
  <path d="M50 5 L62 12 L76 10 L82 22 L94 28 L92 42 L100 54 L92 66 L94 80 L82 86 L76 98 L62 96 L50 103 L38 96 L24 98 L18 86 L6 80 L8 66 L0 54 L8 42 L6 28 L18 22 L24 10 L38 12Z" fill="#FF9800"/>
  <circle cx="50" cy="50" r="28" fill="#FFC107"/>
  <polygon points="50,28 56,42 72,42 59,52 64,66 50,57 36,66 41,52 28,42 44,42" fill="#FF6F00"/>
</svg>''';

const _rosette = '''<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
  <circle cx="50" cy="50" r="30" fill="#FF4444"/>
  <circle cx="50" cy="50" r="30" fill="none" stroke="#CC0000" stroke-width="3" stroke-dasharray="6 4"/>
  <circle cx="50" cy="50" r="20" fill="#FFFFFF"/>
  <polygon points="50,34 53,44 64,44 55,51 58,61 50,55 42,61 45,51 36,44 47,44" fill="#FFD700"/>
</svg>''';

// ── SETAS / DIREÇÃO ────────────────────────────────────────────────────────
const _arrowRight = '''<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
  <path d="M10 42 L60 42 L60 28 L90 50 L60 72 L60 58 L10 58Z" fill="#FF6B35"/>
</svg>''';

const _arrowUp = '''<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
  <path d="M58 90 L58 40 L72 40 L50 10 L28 40 L42 40 L42 90Z" fill="#4CAF50"/>
</svg>''';

const _arrowCurved = '''<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
  <path d="M15 70 C15 30 60 15 85 25" fill="none" stroke="#FF9800" stroke-width="8" stroke-linecap="round"/>
  <polygon points="85,25 68,15 72,35" fill="#FF9800"/>
</svg>''';

const _doubleArrow = '''<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
  <path d="M5 50 L28 30 L28 42 L72 42 L72 30 L95 50 L72 70 L72 58 L28 58 L28 70Z" fill="#9C27B0"/>
</svg>''';

// ── OBJETOS / ACESSÓRIOS ───────────────────────────────────────────────────
const _anchor = '''<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
  <circle cx="50" cy="22" r="10" fill="none" stroke="#1A3F6F" stroke-width="6"/>
  <line x1="50" y1="32" x2="50" y2="85" stroke="#1A3F6F" stroke-width="6" stroke-linecap="round"/>
  <path d="M26 55 A24 24 0 0 0 74 55" fill="none" stroke="#1A3F6F" stroke-width="6" stroke-linecap="round"/>
  <line x1="26" y1="55" x2="18" y2="70" stroke="#1A3F6F" stroke-width="6" stroke-linecap="round"/>
  <line x1="74" y1="55" x2="82" y2="70" stroke="#1A3F6F" stroke-width="6" stroke-linecap="round"/>
  <line x1="26" y1="35" x2="74" y2="35" stroke="#1A3F6F" stroke-width="6" stroke-linecap="round"/>
</svg>''';

const _musicalNote = '''<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
  <rect x="40" y="15" width="8" height="52" rx="4" fill="#9B59B6"/>
  <rect x="55" y="10" width="8" height="42" rx="4" fill="#9B59B6"/>
  <rect x="40" y="15" width="23" height="8" rx="4" fill="#9B59B6"/>
  <ellipse cx="36" cy="68" rx="14" ry="10" fill="#9B59B6" transform="rotate(-15 36 68)"/>
  <ellipse cx="52" cy="52" rx="14" ry="10" fill="#9B59B6" transform="rotate(-15 52 52)"/>
</svg>''';

const _musicalNotes = '''<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
  <path d="M20 55 L20 30 L55 22 L55 47" fill="none" stroke="#E91E63" stroke-width="5" stroke-linecap="round" stroke-linejoin="round"/>
  <circle cx="15" cy="60" r="8" fill="#E91E63"/>
  <circle cx="50" cy="52" r="8" fill="#E91E63"/>
  <path d="M62 70 L62 45 L90 38 L90 62" fill="none" stroke="#FF9800" stroke-width="4" stroke-linecap="round" stroke-linejoin="round"/>
  <circle cx="58" cy="74" r="7" fill="#FF9800"/>
  <circle cx="86" cy="66" r="7" fill="#FF9800"/>
</svg>''';

const _paintBrush = '''<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
  <rect x="44" y="8" width="12" height="55" rx="4" fill="#8B4513" transform="rotate(30 50 35)"/>
  <rect x="44" y="8" width="12" height="20" rx="2" fill="#C0C0C0" transform="rotate(30 50 35)"/>
  <path d="M55 68 C60 72 62 80 58 86 C54 92 46 94 40 90 C34 86 33 78 37 72 C41 66 50 64 55 68Z" fill="#E74C3C"/>
</svg>''';

const _magicWand = '''<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
  <rect x="46" y="48" width="10" height="46" rx="5" fill="#8B6914" transform="rotate(-45 50 50)"/>
  <polygon points="50,5 53,14 62,14 55,20 58,29 50,23 42,29 45,20 38,14 47,14" fill="#FFD700"/>
  <circle cx="22" cy="22" r="4" fill="#FF69B4" opacity="0.8"/>
  <circle cx="78" cy="25" r="3" fill="#00CFFF" opacity="0.8"/>
  <circle cx="18" cy="58" r="3" fill="#FFD700" opacity="0.8"/>
  <circle cx="82" cy="60" r="4" fill="#9B59B6" opacity="0.8"/>
</svg>''';

const _camera = '''<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
  <rect x="8" y="30" width="84" height="58" rx="10" fill="#37474F"/>
  <path d="M35 30 L40 18 L60 18 L65 30Z" fill="#37474F"/>
  <circle cx="50" cy="60" r="20" fill="#546E7A"/>
  <circle cx="50" cy="60" r="14" fill="#78909C"/>
  <circle cx="50" cy="60" r="8" fill="#263238"/>
  <circle cx="46" cy="56" r="3" fill="white" opacity="0.4"/>
  <rect x="72" y="38" width="12" height="8" rx="3" fill="#FFD700"/>
</svg>''';

const _speechBubble = '''<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
  <rect x="8" y="8" width="78" height="58" rx="14" fill="#FFFFFF"/>
  <polygon points="25,66 40,66 30,85" fill="#FFFFFF"/>
  <rect x="8" y="8" width="78" height="58" rx="14" fill="none" stroke="#CCCCCC" stroke-width="2"/>
  <line x1="22" y1="30" x2="72" y2="30" stroke="#AAAAAA" stroke-width="4" stroke-linecap="round"/>
  <line x1="22" y1="44" x2="60" y2="44" stroke="#AAAAAA" stroke-width="4" stroke-linecap="round"/>
</svg>''';

const _speechBubbleRound = '''<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
  <ellipse cx="48" cy="42" rx="42" ry="32" fill="#E3F2FD"/>
  <ellipse cx="48" cy="42" rx="42" ry="32" fill="none" stroke="#90CAF9" stroke-width="3"/>
  <circle cx="25" cy="80" r="8" fill="#E3F2FD" stroke="#90CAF9" stroke-width="2"/>
  <circle cx="18" cy="92" r="5" fill="#E3F2FD" stroke="#90CAF9" stroke-width="2"/>
  <circle cx="36" cy="28" r="5" fill="#90CAF9"/>
  <circle cx="50" cy="28" r="5" fill="#90CAF9"/>
  <circle cx="64" cy="28" r="5" fill="#90CAF9"/>
</svg>''';

// ── CELEBRAÇÃO / DIVERSÃO ──────────────────────────────────────────────────
const _balloon = '''<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
  <ellipse cx="50" cy="42" rx="32" ry="38" fill="#FF4081"/>
  <ellipse cx="40" cy="28" rx="10" ry="8" fill="#FF80AB" opacity="0.5"/>
  <path d="M50 80 C48 86 52 90 50 95" stroke="#FF4081" stroke-width="2" fill="none"/>
  <path d="M46 80 L54 80 L52 84 L48 84Z" fill="#FF4081"/>
</svg>''';

const _partyPopper = '''<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
  <path d="M10 90 L45 55 L55 65Z" fill="#FF9800"/>
  <path d="M45 55 L85 15 L55 65Z" fill="#FFC107"/>
  <circle cx="72" cy="28" r="6" fill="#F44336"/>
  <circle cx="85" cy="45" r="4" fill="#4CAF50"/>
  <circle cx="60" cy="15" r="5" fill="#2196F3"/>
  <circle cx="90" cy="20" r="3" fill="#9C27B0"/>
  <circle cx="55" cy="35" r="3" fill="#FF4081"/>
  <path d="M62 20 C68 15 72 10 78 12" stroke="#FFD700" stroke-width="3" fill="none" stroke-linecap="round"/>
  <path d="M75 30 C82 25 88 28 90 35" stroke="#00BCD4" stroke-width="3" fill="none" stroke-linecap="round"/>
</svg>''';

const _confetti = '''<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
  <rect x="10" y="15" width="10" height="10" rx="2" fill="#FF4444" transform="rotate(20 15 20)"/>
  <rect x="35" y="8" width="8" height="8" rx="2" fill="#FFD700" transform="rotate(-15 39 12)"/>
  <rect x="60" y="12" width="10" height="10" rx="2" fill="#4CAF50" transform="rotate(30 65 17)"/>
  <rect x="80" y="20" width="8" height="8" rx="2" fill="#2196F3" transform="rotate(-25 84 24)"/>
  <rect x="15" y="45" width="8" height="8" rx="2" fill="#9C27B0" transform="rotate(40 19 49)"/>
  <rect x="55" y="40" width="10" height="6" rx="2" fill="#FF9800" transform="rotate(-10 60 43)"/>
  <rect x="78" y="50" width="8" height="8" rx="2" fill="#E91E63" transform="rotate(35 82 54)"/>
  <circle cx="30" cy="30" r="5" fill="#FF6B9D"/>
  <circle cx="70" cy="35" r="4" fill="#00BCD4"/>
  <circle cx="45" cy="55" r="5" fill="#FFEB3B"/>
  <circle cx="88" cy="35" r="3" fill="#FF5722"/>
  <circle cx="20" cy="70" r="4" fill="#8BC34A"/>
  <circle cx="65" cy="70" r="5" fill="#3F51B5"/>
  <rect x="40" y="75" width="10" height="6" rx="2" fill="#F44336" transform="rotate(15 45 78)"/>
  <rect x="75" y="75" width="8" height="8" rx="2" fill="#009688" transform="rotate(-20 79 79)"/>
</svg>''';

const _gift = '''<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
  <rect x="12" y="48" width="76" height="44" rx="4" fill="#E53935"/>
  <rect x="8" y="36" width="84" height="18" rx="4" fill="#EF9A9A"/>
  <rect x="44" y="36" width="12" height="56" fill="#FFCDD2"/>
  <path d="M50 36 C50 36 35 30 30 20 C27 13 34 8 40 12 C46 16 50 28 50 36Z" fill="#F44336"/>
  <path d="M50 36 C50 36 65 30 70 20 C73 13 66 8 60 12 C54 16 50 28 50 36Z" fill="#D32F2F"/>
  <path d="M50 36 C46 28 46 18 50 12 C54 18 54 28 50 36Z" fill="#FFCDD2"/>
</svg>''';

// ── ASTROS / ESPAÇO ────────────────────────────────────────────────────────
const _planet = '''<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
  <ellipse cx="50" cy="50" rx="72" ry="14" fill="none" stroke="#B0BEC5" stroke-width="6" transform="rotate(-20 50 50)"/>
  <circle cx="50" cy="50" r="28" fill="#7E57C2"/>
  <circle cx="38" cy="40" r="12" fill="#9575CD" opacity="0.7"/>
  <circle cx="36" cy="38" r="5" fill="#B39DDB" opacity="0.5"/>
</svg>''';

const _rocket = '''<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
  <path d="M50 5 C50 5 70 20 70 55 L50 65 L30 55 C30 20 50 5 50 5Z" fill="#E0E0E0"/>
  <path d="M50 5 C50 5 62 20 62 50 L50 58 L38 50 C38 20 50 5 50 5Z" fill="#FAFAFA"/>
  <circle cx="50" cy="40" r="10" fill="#42A5F5"/>
  <circle cx="50" cy="40" r="6" fill="#90CAF9"/>
  <path d="M30 55 L18 72 L30 68Z" fill="#FF5722"/>
  <path d="M70 55 L82 72 L70 68Z" fill="#FF5722"/>
  <path d="M42 65 C40 78 38 85 35 90" stroke="#FF9800" stroke-width="5" stroke-linecap="round" fill="none"/>
  <path d="M58 65 C60 78 62 85 65 90" stroke="#FF9800" stroke-width="5" stroke-linecap="round" fill="none"/>
  <path d="M46 68 C46 82 48 88 50 92" stroke="#FFD700" stroke-width="4" stroke-linecap="round" fill="none"/>
  <path d="M54 68 C54 82 52 88 50 92" stroke="#FFD700" stroke-width="4" stroke-linecap="round" fill="none"/>
</svg>''';

const _ufo = '''<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
  <ellipse cx="50" cy="62" rx="44" ry="16" fill="#78909C"/>
  <path d="M50 20 C30 20 20 40 20 52 L80 52 C80 40 70 20 50 20Z" fill="#B0BEC5"/>
  <ellipse cx="50" cy="35" rx="18" ry="20" fill="#80DEEA"/>
  <ellipse cx="44" cy="30" rx="7" ry="9" fill="#E0F7FA" opacity="0.6"/>
  <circle cx="28" cy="68" r="5" fill="#4FC3F7" opacity="0.8"/>
  <circle cx="42" cy="72" r="4" fill="#81D4FA" opacity="0.8"/>
  <circle cx="58" cy="72" r="4" fill="#81D4FA" opacity="0.8"/>
  <circle cx="72" cy="68" r="5" fill="#4FC3F7" opacity="0.8"/>
  <path d="M35 75 L28 90" stroke="#4FC3F7" stroke-width="2" opacity="0.6"/>
  <path d="M50 76 L50 92" stroke="#4FC3F7" stroke-width="2" opacity="0.6"/>
  <path d="M65 75 L72 90" stroke="#4FC3F7" stroke-width="2" opacity="0.6"/>
</svg>''';

// ── FOOD / DRINKS ──────────────────────────────────────────────────────────
const _iceCream = '''<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
  <path d="M35 55 L50 95 L65 55Z" fill="#FFC107"/>
  <circle cx="38" cy="45" r="22" fill="#F48FB1"/>
  <circle cx="62" cy="42" r="22" fill="#CE93D8"/>
  <circle cx="50" cy="32" r="18" fill="#80DEEA"/>
  <circle cx="32" cy="38" r="5" fill="#F8BBD0" opacity="0.5"/>
  <circle cx="65" cy="34" r="4" fill="#E1BEE7" opacity="0.5"/>
</svg>''';

const _pizza = '''<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
  <path d="M50 10 L95 85 L5 85Z" fill="#FF9800"/>
  <path d="M50 10 L95 85 L5 85Z" fill="none" stroke="#E65100" stroke-width="2"/>
  <path d="M50 25 L85 82 L15 82Z" fill="#FFCC80"/>
  <circle cx="40" cy="55" r="6" fill="#E53935"/>
  <circle cx="58" cy="65" r="6" fill="#E53935"/>
  <circle cx="50" cy="45" r="5" fill="#E53935"/>
  <circle cx="34" cy="70" r="4" fill="#4CAF50"/>
  <circle cx="64" cy="52" r="4" fill="#4CAF50"/>
</svg>''';

// ── MISC ARTÍSTICO ─────────────────────────────────────────────────────────
const _crown2 = '''<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
  <path d="M5 80 L5 40 L25 65 L50 10 L75 65 L95 40 L95 80Z" fill="none" stroke="#FFD700" stroke-width="5" stroke-linejoin="round"/>
  <circle cx="50" cy="10" r="7" fill="#FFD700"/>
  <circle cx="5" cy="40" r="5" fill="#FFD700"/>
  <circle cx="95" cy="40" r="5" fill="#FFD700"/>
  <rect x="5" y="78" width="90" height="10" rx="3" fill="#FFD700"/>
</svg>''';

const _eyeArt = '''<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
  <path d="M5 50 C20 20 80 20 95 50 C80 80 20 80 5 50Z" fill="#E3F2FD"/>
  <circle cx="50" cy="50" r="22" fill="#1565C0"/>
  <circle cx="50" cy="50" r="14" fill="#0D47A1"/>
  <circle cx="50" cy="50" r="6" fill="#000000"/>
  <circle cx="44" cy="44" r="4" fill="white"/>
  <circle cx="56" cy="56" r="2" fill="white" opacity="0.6"/>
  <path d="M5 50 C20 20 80 20 95 50" fill="none" stroke="#1565C0" stroke-width="3"/>
</svg>''';

const _compass = '''<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
  <circle cx="50" cy="50" r="44" fill="none" stroke="#546E7A" stroke-width="5"/>
  <circle cx="50" cy="50" r="38" fill="#ECEFF1"/>
  <polygon points="50,12 55,48 50,52 45,48" fill="#F44336"/>
  <polygon points="50,88 55,52 50,48 45,52" fill="#37474F"/>
  <polygon points="12,50 48,45 52,50 48,55" fill="#F44336"/>
  <polygon points="88,50 52,45 48,50 52,55" fill="#37474F"/>
  <circle cx="50" cy="50" r="5" fill="#37474F"/>
  <text x="50" y="18" text-anchor="middle" font-size="10" font-weight="bold" fill="#F44336">N</text>
  <text x="50" y="90" text-anchor="middle" font-size="10" fill="#37474F">S</text>
  <text x="82" y="54" text-anchor="middle" font-size="10" fill="#37474F">L</text>
  <text x="16" y="54" text-anchor="middle" font-size="10" fill="#37474F">O</text>
</svg>''';

const _paintPalette = '''<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
  <path d="M50 10 C25 10 5 28 5 50 C5 62 12 72 24 78 C30 81 34 76 32 70 C30 64 34 58 40 58 C47 58 52 64 52 70 C52 80 62 88 74 82 C88 74 95 62 95 50 C95 28 75 10 50 10Z" fill="#FFF9C4"/>
  <path d="M50 10 C25 10 5 28 5 50 C5 62 12 72 24 78 C30 81 34 76 32 70 C30 64 34 58 40 58 C47 58 52 64 52 70 C52 80 62 88 74 82 C88 74 95 62 95 50 C95 28 75 10 50 10Z" fill="none" stroke="#FBC02D" stroke-width="2"/>
  <circle cx="30" cy="30" r="8" fill="#F44336"/>
  <circle cx="50" cy="22" r="8" fill="#FF9800"/>
  <circle cx="70" cy="30" r="8" fill="#FFEB3B"/>
  <circle cx="78" cy="50" r="8" fill="#4CAF50"/>
  <circle cx="72" cy="70" r="8" fill="#2196F3"/>
  <circle cx="40" cy="75" r="6" fill="#9C27B0"/>
</svg>''';

// ---------------------------------------------------------------------------
// Sticker list — 60 SVGs
// ---------------------------------------------------------------------------

final List<StickerEntity> localSvgStickers = [
  // Amor
  StickerEntity(id: 'svg_heart', name: 'Coração', assetPath: _heart, category: StickerCategory.shapes, renderType: StickerRenderType.svg),
  StickerEntity(id: 'svg_heart_outline', name: 'Coração Contorno', assetPath: _heartOutline, category: StickerCategory.shapes, renderType: StickerRenderType.svg),
  StickerEntity(id: 'svg_heart_broken', name: 'Coração Partido', assetPath: _heartBroken, category: StickerCategory.shapes, renderType: StickerRenderType.svg),
  StickerEntity(id: 'svg_infinity', name: 'Infinito', assetPath: _infinity, category: StickerCategory.shapes, renderType: StickerRenderType.svg),
  StickerEntity(id: 'svg_ribbon', name: 'Laço', assetPath: _ribbon, category: StickerCategory.shapes, renderType: StickerRenderType.svg),
  // Natureza
  StickerEntity(id: 'svg_sun', name: 'Sol', assetPath: _sun, category: StickerCategory.shapes, renderType: StickerRenderType.svg),
  StickerEntity(id: 'svg_moon', name: 'Lua', assetPath: _moon, category: StickerCategory.shapes, renderType: StickerRenderType.svg),
  StickerEntity(id: 'svg_rainbow', name: 'Arco-íris', assetPath: _rainbow, category: StickerCategory.shapes, renderType: StickerRenderType.svg),
  StickerEntity(id: 'svg_cloud', name: 'Nuvem', assetPath: _cloud, category: StickerCategory.shapes, renderType: StickerRenderType.svg),
  StickerEntity(id: 'svg_cloud_rain', name: 'Chuva', assetPath: _cloudRain, category: StickerCategory.shapes, renderType: StickerRenderType.svg),
  StickerEntity(id: 'svg_snowflake', name: 'Floco de Neve', assetPath: _snowflake, category: StickerCategory.shapes, renderType: StickerRenderType.svg),
  StickerEntity(id: 'svg_lightning', name: 'Raio', assetPath: _lightning, category: StickerCategory.shapes, renderType: StickerRenderType.svg),
  StickerEntity(id: 'svg_fire', name: 'Fogo', assetPath: _fire, category: StickerCategory.shapes, renderType: StickerRenderType.svg),
  StickerEntity(id: 'svg_wave', name: 'Ondas', assetPath: _wave, category: StickerCategory.shapes, renderType: StickerRenderType.svg),
  StickerEntity(id: 'svg_flower', name: 'Flor', assetPath: _flower, category: StickerCategory.shapes, renderType: StickerRenderType.svg),
  StickerEntity(id: 'svg_sunflower', name: 'Girassol', assetPath: _sunflower, category: StickerCategory.shapes, renderType: StickerRenderType.svg),
  StickerEntity(id: 'svg_leaf', name: 'Folha', assetPath: _leaf, category: StickerCategory.shapes, renderType: StickerRenderType.svg),
  StickerEntity(id: 'svg_butterfly', name: 'Borboleta', assetPath: _butterfly, category: StickerCategory.shapes, renderType: StickerRenderType.svg),
  // Formas
  StickerEntity(id: 'svg_star', name: 'Estrela', assetPath: _star, category: StickerCategory.shapes, renderType: StickerRenderType.svg),
  StickerEntity(id: 'svg_star_outline', name: 'Estrela Contorno', assetPath: _starOutline, category: StickerCategory.shapes, renderType: StickerRenderType.svg),
  StickerEntity(id: 'svg_sparkle', name: 'Brilho', assetPath: _sparkle, category: StickerCategory.shapes, renderType: StickerRenderType.svg),
  StickerEntity(id: 'svg_diamond', name: 'Diamante', assetPath: _diamond, category: StickerCategory.shapes, renderType: StickerRenderType.svg),
  StickerEntity(id: 'svg_hexagon', name: 'Hexágono', assetPath: _hexagon, category: StickerCategory.shapes, renderType: StickerRenderType.svg),
  StickerEntity(id: 'svg_triangle', name: 'Triângulo', assetPath: _triangle, category: StickerCategory.shapes, renderType: StickerRenderType.svg),
  StickerEntity(id: 'svg_circle3d', name: 'Círculo 3D', assetPath: _circle3d, category: StickerCategory.shapes, renderType: StickerRenderType.svg),
  StickerEntity(id: 'svg_cross', name: 'Cruz', assetPath: _cross, category: StickerCategory.shapes, renderType: StickerRenderType.svg),
  // Símbolos
  StickerEntity(id: 'svg_crown', name: 'Coroa', assetPath: _crown, category: StickerCategory.shapes, renderType: StickerRenderType.svg),
  StickerEntity(id: 'svg_crown2', name: 'Coroa Contorno', assetPath: _crown2, category: StickerCategory.shapes, renderType: StickerRenderType.svg),
  StickerEntity(id: 'svg_shield', name: 'Escudo', assetPath: _shield, category: StickerCategory.shapes, renderType: StickerRenderType.svg),
  StickerEntity(id: 'svg_trophy', name: 'Troféu', assetPath: _trophy, category: StickerCategory.shapes, renderType: StickerRenderType.svg),
  StickerEntity(id: 'svg_badge', name: 'Medalha', assetPath: _badge, category: StickerCategory.shapes, renderType: StickerRenderType.svg),
  StickerEntity(id: 'svg_rosette', name: 'Roseta', assetPath: _rosette, category: StickerCategory.shapes, renderType: StickerRenderType.svg),
  // Setas
  StickerEntity(id: 'svg_arrow_right', name: 'Seta Direita', assetPath: _arrowRight, category: StickerCategory.shapes, renderType: StickerRenderType.svg),
  StickerEntity(id: 'svg_arrow_up', name: 'Seta Cima', assetPath: _arrowUp, category: StickerCategory.shapes, renderType: StickerRenderType.svg),
  StickerEntity(id: 'svg_arrow_curved', name: 'Seta Curva', assetPath: _arrowCurved, category: StickerCategory.shapes, renderType: StickerRenderType.svg),
  StickerEntity(id: 'svg_double_arrow', name: 'Seta Dupla', assetPath: _doubleArrow, category: StickerCategory.shapes, renderType: StickerRenderType.svg),
  // Objetos
  StickerEntity(id: 'svg_anchor', name: 'Âncora', assetPath: _anchor, category: StickerCategory.shapes, renderType: StickerRenderType.svg),
  StickerEntity(id: 'svg_musical_note', name: 'Nota Musical', assetPath: _musicalNote, category: StickerCategory.shapes, renderType: StickerRenderType.svg),
  StickerEntity(id: 'svg_musical_notes', name: 'Notas Musicais', assetPath: _musicalNotes, category: StickerCategory.shapes, renderType: StickerRenderType.svg),
  StickerEntity(id: 'svg_paint_brush', name: 'Pincel', assetPath: _paintBrush, category: StickerCategory.shapes, renderType: StickerRenderType.svg),
  StickerEntity(id: 'svg_magic_wand', name: 'Varinha Mágica', assetPath: _magicWand, category: StickerCategory.shapes, renderType: StickerRenderType.svg),
  StickerEntity(id: 'svg_camera', name: 'Câmera', assetPath: _camera, category: StickerCategory.shapes, renderType: StickerRenderType.svg),
  StickerEntity(id: 'svg_speech_bubble', name: 'Balão de Fala', assetPath: _speechBubble, category: StickerCategory.shapes, renderType: StickerRenderType.svg),
  StickerEntity(id: 'svg_speech_round', name: 'Balão Redondo', assetPath: _speechBubbleRound, category: StickerCategory.shapes, renderType: StickerRenderType.svg),
  // Celebração
  StickerEntity(id: 'svg_balloon', name: 'Balão', assetPath: _balloon, category: StickerCategory.shapes, renderType: StickerRenderType.svg),
  StickerEntity(id: 'svg_party_popper', name: 'Festa', assetPath: _partyPopper, category: StickerCategory.shapes, renderType: StickerRenderType.svg),
  StickerEntity(id: 'svg_confetti', name: 'Confete', assetPath: _confetti, category: StickerCategory.shapes, renderType: StickerRenderType.svg),
  StickerEntity(id: 'svg_gift', name: 'Presente', assetPath: _gift, category: StickerCategory.shapes, renderType: StickerRenderType.svg),
  // Espaço
  StickerEntity(id: 'svg_planet', name: 'Planeta', assetPath: _planet, category: StickerCategory.shapes, renderType: StickerRenderType.svg),
  StickerEntity(id: 'svg_rocket', name: 'Foguete', assetPath: _rocket, category: StickerCategory.shapes, renderType: StickerRenderType.svg),
  StickerEntity(id: 'svg_ufo', name: 'OVNI', assetPath: _ufo, category: StickerCategory.shapes, renderType: StickerRenderType.svg),
  // Comida
  StickerEntity(id: 'svg_ice_cream', name: 'Sorvete', assetPath: _iceCream, category: StickerCategory.shapes, renderType: StickerRenderType.svg),
  StickerEntity(id: 'svg_pizza', name: 'Pizza', assetPath: _pizza, category: StickerCategory.shapes, renderType: StickerRenderType.svg),
  // Arte
  StickerEntity(id: 'svg_eye_art', name: 'Olho', assetPath: _eyeArt, category: StickerCategory.shapes, renderType: StickerRenderType.svg),
  StickerEntity(id: 'svg_compass', name: 'Bússola', assetPath: _compass, category: StickerCategory.shapes, renderType: StickerRenderType.svg),
  StickerEntity(id: 'svg_paint_palette', name: 'Paleta', assetPath: _paintPalette, category: StickerCategory.shapes, renderType: StickerRenderType.svg),
];
