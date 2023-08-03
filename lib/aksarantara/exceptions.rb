module aksarantara
  class SchemeNotSupportedError < StandardError
    def initialize(scheme = :unknown)
      super(":#{scheme} is not supported.")
    end
  end

  class DetectionError < StandardError
    def initialize(message = "String detection failed.")
      super
    end
  end
end
