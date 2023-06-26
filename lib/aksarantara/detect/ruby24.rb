# frozen_string_literal: true

module aksarantara
  module Detect
    # Module implementing `detect_scheme` method using Ruby 2.4's faster Regexp#match? method
    # (Note: This module will only load if chosen by {aksarantara::Detect}.)
    module Ruby24
      # Attempts to detect the encoding scheme of the provided string.
      # Uses Ruby 2.4's Regexp#match? method for additional speed.
      #
      # @param text [String] a string of Sanskrit text
      # @return [Symbol, nil] the Symbol of the scheme, or nil if no match
      def ruby_detect_scheme(text) # rubocop:disable AbcSize, PerceivedComplexity
        text = text.to_str.gsub(RE_CONTROL_BLOCK, "")

        # Brahmic schemes are all within a specific range of code points.
        brahmic_char = text[RE_BRAHMIC_RANGE]
        return BRAHMIC_SCRIPTS_ORDER[(brahmic_char.ord - 0x0900) / 0x80] if brahmic_char

        # Romanizations
        if RE_IAST_OR_KOLKATA_ONLY.match?(text)
          return :kolkata if RE_KOLKATA_ONLY.match?(text)
          :iast
        elsif RE_ITRANS_ONLY.match?(text)
          :itrans
        elsif RE_SLP1_ONLY.match?(text)
          :slp1
        elsif RE_VELTHUIS_ONLY.match?(text)
          :velthuis
        elsif RE_ITRANS_OR_VELTHUIS_ONLY.match?(text)
          :itrans
        elsif RE_HARVARD_KYOTO.match?(text)
          :hk
        end
      end
    end
  end
end
