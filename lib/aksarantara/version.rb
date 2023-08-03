require 'pathname'

module Aksarantara
  VERSION = "1.0.0"

  GEM_ROOT = Pathname.new(File.realpath(File.join(__dir__, "..", "..")))
  private_constant :GEM_ROOT
end
