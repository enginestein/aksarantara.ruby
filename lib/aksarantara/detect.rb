require "aksarantara/detect/constants"

module aksarantara
  module Detect
    if Regexp.method_defined?(:match?)
      require "aksarantara/detect/ruby24"
      extend Ruby24
    else
      require "aksarantara/detect/ruby2x"
      extend Ruby2x
    end
    singleton_class.send(:alias_method, :detect_scheme, :ruby_detect_scheme)
  end
end
