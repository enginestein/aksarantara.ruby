pub mod ruby;

use regex::Regex;

lazy_static! {
  static ref RE_ESCAPED_CONTROL_CHAR: Regex = Regex::new(r"\\(?:\{#|##|#\})").unwrap();
  static ref RE_CONTROL_BLOCK: Regex = Regex::new(r"##.*?##|\{#.*?#\}").unwrap();
  static ref RE_IAST_OR_KOLKATA_ONLY: Regex = Regex::new(r"[āīūṛṝḷḹēōṃḥṅñṭḍṇśṣḻĀĪŪṚṜḶḸĒŌṂḤṄÑṬḌṆŚṢḺ]|[aiueoAIUEO]\x{0304}|[rlRL]\x{0323}\x{0304}?|[mhtdMHTD]\x{0323}|[nN][\x{0307}\x{0303}\x{0323}]|[sS][\x{0301}\x{0323}]|[lL]\x{0331}").unwrap();
  static ref RE_KOLKATA_ONLY: Regex = Regex::new(r"[ēōĒŌ]|[eoEO]\x{0304}").unwrap();
  static ref RE_ITRANS_ONLY: Regex = Regex::new(r"ee|oo|\^[iI]|RR[iI]|L[iI]|~N|N\^|Ch|chh|JN|sh|Sh|\.a").unwrap();
  static ref RE_SLP1_ONLY: Regex = Regex::new(r"[fFxXEOCYwWqQPB]|kz|N[kg]|tT|dD|S[cn]|[aAiIuUeo]R|G[yr]").unwrap();
  static ref RE_VELTHUIS_ONLY: Regex = Regex::new(r"\.[mhnrlntds]|\x22n|~s").unwrap();
  static ref RE_ITRANS_OR_VELTHUIS_ONLY: Regex = Regex::new(r"aa|ii|uu|~n").unwrap();
  static ref RE_HARVARD_KYOTO: Regex = Regex::new(r"[aAiIuUeoRMHkgGcjJTDNtdnpbmyrlvzSsh]").unwrap();
}

fn first_brahmic_char(s: &str) -> usize {
    for c in s.chars() {
        if let 0x0900...0x0D7F = c as usize {
            return c as usize;
        }
    }
    0
}

#[no_mangle]
pub extern "C" fn detect_scheme(s: &str) -> usize {
    let r_str = &RE_ESCAPED_CONTROL_CHAR.replace_all(s, "");
    let r_str = &RE_CONTROL_BLOCK.replace_all(r_str, "");
    let brahmic_codepoint = first_brahmic_char(r_str);
    if brahmic_codepoint != 0 {
        return match brahmic_codepoint {
            0x0900...0x097F => 1, // Devanagari
            0x0980...0x09FF => 2, // Bengali
            0x0A00...0x0A7F => 3, // Gurmukhi
            0x0A80...0x0AFF => 4, // Gujarati
            0x0B00...0x0B7F => 5, // Oriya
            0x0B80...0x0BFF => 6, // Tamil
            0x0C00...0x0C7F => 7, // Telugu
            0x0C80...0x0CFF => 8, // Kannada
            0x0D00...0x0D7F => 9, // Malayalam
            _ => 0,
        };
    }

    if RE_IAST_OR_KOLKATA_ONLY.is_match(r_str) {
        if RE_KOLKATA_ONLY.is_match(r_str) {
            11 
        } else {
            10
        }
    } else if RE_ITRANS_ONLY.is_match(r_str) {
        12 
    } else if RE_SLP1_ONLY.is_match(r_str) {
        13 
    } else if RE_VELTHUIS_ONLY.is_match(r_str) {
        14 
    } else if RE_ITRANS_OR_VELTHUIS_ONLY.is_match(r_str) {
        12 
    } else if RE_HARVARD_KYOTO.is_match(r_str) {
        15 
    } else {
        0 
    }
}
