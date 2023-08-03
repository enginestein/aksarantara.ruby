# frozen_string_literal: true

module aksarantara
  module Detect
    module Ruby24
      def ruby_detect_scheme(text) 
        text = text.to_str.gsub(RE_CONTROL_BLOCK, "")
        brahmic_char = text[RE_BRAHMIC_RANGE]
        return BRAHMIC_SCRIPTS_ORDER[(brahmic_char.ord - 0x0900) / 0x80] if brahmic_char
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
