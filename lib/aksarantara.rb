require "active_support/core_ext/object/deep_dup"
require "ice_nine"

require "aksarantara/version"
require "aksarantara/rust"
require "aksarantara/exceptions"
require "aksarantara/detect"
require "aksarantara/transliterate"
require "aksarantara/benchmark"

module aksarantara
  
  RUST_AVAILABLE = rust_load!
  rust_enable! if RUST_AVAILABLE

  module_function

  def detect(text)
    Detect.detect_scheme(text)
  end
  
  def transliterate(text, from, to = nil, **opts)
    if to.nil?
      to = from
      from = nil
    end
    if from.nil?
      from = Detect.detect_scheme(text) || opts[:default_scheme] ||
             raise(DetectionError, "String detection and fallback failed.")
    end
    Transliterate.transliterate(text, from, to, opts)
  end
end
