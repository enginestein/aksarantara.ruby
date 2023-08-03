use detect;

use rb;
use rb::{CallbackPtr, Value, RB_NIL};


lazy_static! {
  
  static ref RUBY_RESULTS: [Value; 16] = [
    RB_NIL,                  
    str2sym!("devanagari"),  
    str2sym!("bengali") ,    
    str2sym!("gurmukhi"),    
    str2sym!("gujarati"),    
    str2sym!("oriya"),       
    str2sym!("tamil"),       
    str2sym!("telugu"),      
    str2sym!("kannada"),     
    str2sym!("malayalam"),   
    str2sym!("iast"),        
    str2sym!("kolkata"),     
    str2sym!("itrans"),      
    str2sym!("slp1"),        
    str2sym!("velthuis"),    
    str2sym!("hk")           
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
