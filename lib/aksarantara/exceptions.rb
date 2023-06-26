# frozen_string_literal: true

module aksarantara
  # Error for when transliteration scheme is not supported.
  class SchemeNotSupportedError < StandardError
    def initialize(scheme = :unknown)
      super(":#{scheme} is not supported.")
    end
  end

  # Error for when scheme detection should non-silently fail
  # (such as inside a transliteration method).
  class DetectionError < StandardError
    def initialize(message = "String detection failed.")
      super
    end
  end
end
