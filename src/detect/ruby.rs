use detect;

use rb;
use rb::{CallbackPtr, Value, RB_NIL};

// Initialize all of the Ruby-specific static variables.
lazy_static! {
  // Lookup table for Ruby Results
  static ref RUBY_RESULTS: [Value; 16] = [
    RB_NIL,                  // 0
    str2sym!("devanagari"),  // 1
    str2sym!("bengali") ,    // 2
    str2sym!("gurmukhi"),    // 3
    str2sym!("gujarati"),    // 4
    str2sym!("oriya"),       // 5
    str2sym!("tamil"),       // 6
    str2sym!("telugu"),      // 7
    str2sym!("kannada"),     // 8
    str2sym!("malayalam"),   // 9
    str2sym!("iast"),        // 10
    str2sym!("kolkata"),     // 11
    str2sym!("itrans"),      // 12
    str2sym!("slp1"),        // 13
    str2sym!("velthuis"),    // 14
    str2sym!("hk")           // 15
  ];
}

fn rbstr_detect_scheme(_rself: Value, s: Value) -> Value {
    let result = detect::detect_scheme(&rb::rbstr2str(s));
    RUBY_RESULTS[result]
}

#[no_mangle]
pub extern "C" fn init_rusty_aksarantara() {
    let m_aksarantara = rb::define_module("aksarantara");
    let m_detect = rb::define_module_under(m_aksarantara, "Detect");
    let m_rust = rb::define_module_under(m_aksarantara, "Rust");
    let m_rust_detect = rb::define_module_under(m_rust, "Detect");
    rb::define_method(
        m_rust_detect,
        "rust_detect_scheme",
        rbstr_detect_scheme as CallbackPtr,
        1,
    );
    rb::extend_object(m_detect, m_rust_detect);
}
