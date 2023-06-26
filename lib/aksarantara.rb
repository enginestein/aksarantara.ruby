# frozen_string_literal: true

require "active_support/core_ext/object/deep_dup"
require "ice_nine"

require "aksarantara/version"
require "aksarantara/rust"
require "aksarantara/exceptions"
require "aksarantara/detect"
require "aksarantara/transliterate"
require "aksarantara/benchmark"

# aksarantara.rb detection/transliteration module for Sanskrit.
module aksarantara
  # Load rust if available.
  RUST_AVAILABLE = rust_load!
  rust_enable! if RUST_AVAILABLE

  module_function

  # Attempts to detect the encoding scheme of the provided string.
  # Simple proxy for {Detect.detect_scheme}
  #
  # @param text [String] a string of Sanskrit text
  # @return [Symbol, nil] the Symbol of the scheme, or nil if no match
  def detect(text)
    Detect.detect_scheme(text)
  end

  # Transliterates a string from one scheme to another.
  # Proxy for {Transliterate.transliterate}
  #
  # @overload transliterate(text, from, to, **opts)
  #   Transliterates a string from one scheme to another.
  #   @param text [String] the String to transliterate
  #   @param from [Symbol, nil] the name of the scheme to transliterate from, or Nil to detect
  #   @param to [Symbol] the name of the scheme to transliterate to
  #   @option opts [Symbol] :default_scheme a default scheme to fall-back to if detection fails
  #   @option opts [Boolean] :skip_sgml (false) escape SGML-style tags in text string
  #   @option opts [Boolean] :syncope (false) activate Hindi-style schwa syncope
  #   @return [String] the transliterated String
  #
  #   @raise [DetectionError] if scheme detection and fallback fail
  #   @raise [SchemeNotSupportedError] if a provided transliteration scheme is not supported
  #
  # @overload transliterate(text, to, **opts)
  #   Transliterates a string, detecting its source-scheme first.
  #   @param text [String] the String to transliterate
  #   @param to [Symbol] the name of the scheme to transliterate to
  #   @option opts [Symbol] :default_scheme a default scheme to fall-back to if detection fails
  #   @option opts [Boolean] :skip_sgml (false) escape SGML-style tags in text string
  #   @option opts [Boolean] :syncope (false) activate Hindi-style schwa syncope
  #   @return [String] the transliterated String
  #
  #   @raise [DetectionError] if scheme detection and fallback fail
  #   @raise [SchemeNotSupportedError] if a provided transliteration scheme is not supported
  #
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
