# frozen_string_literal: true

module aksarantara
  module_function

  # Attempts to load Rust native extension.
  # @return [bool] whether the extension loaded.
  def rust_load!
    # :nocov:
    return RUST_AVAILABLE if defined?(RUST_AVAILABLE)
    require "thermite/fiddle"
    Thermite::Fiddle.load_module("init_rusty_aksarantara",
                                 cargo_project_path: GEM_ROOT,
                                 ruby_project_path: GEM_ROOT)
    defined?(aksarantara::Rust) ? true : false
  rescue Fiddle::DLError
    false
    # :nocov:
  end

  # @return [bool] the enabled status of the Rust extension
  def rust_enabled?
    @rust_enabled ||= false
  end

  # Turns on Rust extension, if available.
  # @return [bool] the enabled status of the Rust extension
  def rust_enable!
    return false unless RUST_AVAILABLE
    Detect.singleton_class.class_eval do
      alias_method :detect_scheme, :rust_detect_scheme
    end
    @rust_enabled = true
  end

  # Turns off Rust native extension.
  # @return [bool] the enabled status of the Rust extension
  def rust_disable!
    Detect.singleton_class.class_eval do
      alias_method :detect_scheme, :ruby_detect_scheme
    end
    @rust_enabled = false
  end
end
