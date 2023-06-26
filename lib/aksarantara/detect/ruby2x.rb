# frozen_string_literal: true

module aksarantara
  module Detect
    # Module implementing `detect_scheme` method using Ruby 2.x-compatible syntax.
    # (Note: This module will only load if chosen by {aksarantara::Detect}.)
    module Ruby2x
      # Attempts to detect the encoding scheme of the provided string.
      #
      # @param text [String] a string of Sanskrit text
      # @return [Symbol, nil] the Symbol of the scheme, or nil if no match
      def ruby_detect_scheme(text) # rubocop:disable AbcSize, PerceivedComplexity
        text = text.to_str.gsub(RE_CONTROL_BLOCK, "")

        # Brahmic schemes are all within a specific range of code points.
        brahmic_char = text[RE_BRAHMIC_RANGE]
        return BRAHMIC_SCRIPTS_ORDER[(brahmic_char.ord - 0x0900) / 0x80] if brahmic_char

        # rubocop:disable Style/CaseEquality

        # Romanizations
        if RE_IAST_OR_KOLKATA_ONLY === text
          return :kolkata if RE_KOLKATA_ONLY === text
          :iast
        elsif RE_ITRANS_ONLY === text
          :itrans
        elsif RE_SLP1_ONLY === text
          :slp1
        elsif RE_VELTHUIS_ONLY === text
          :velthuis
        elsif RE_ITRANS_OR_VELTHUIS_ONLY === text
          :itrans
        elsif RE_HARVARD_KYOTO === text
          :hk
        end
        # rubocop:enable Style/CaseEquality
      end
    end
  end
end
