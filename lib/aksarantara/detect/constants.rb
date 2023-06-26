# frozen_string_literal: true

module aksarantara
  module Detect
    # Constants for scheme detection

    # Match any character in the block of Brahmic scripts
    # between Devanagari and Malayalam.
    RE_BRAHMIC_RANGE = /[\u0900-\u0d7f]/

    # The order of individual brahmic scripts in 128 character unicode blocks.
    BRAHMIC_SCRIPTS_ORDER = %i[devanagari bengali gurmukhi gujarati oriya tamil telugu kannada malayalam].freeze

    # Match on special Roman characters
    RE_IAST_OR_KOLKATA_ONLY = /[āīūṛṝḷḹēōṃḥṅñṭḍṇśṣḻĀĪŪṚṜḶḸĒŌṂḤṄÑṬḌṆŚṢḺ]|
                               [aiueoAIUEO]\u0304|[rlRL]\u0323\u0304?|
                               [mhtdMHTD]\u0323|[nN][\u0307\u0303\u0323]|
                               [sS][\u0301\u0323]|[lL]\u0331/x

    # Match on Kolkata-specific Roman characters
    RE_KOLKATA_ONLY = /[ēōĒŌ]|[eoEO]\u0304/

    # Match on ITRANS-only
    RE_ITRANS_ONLY = /ee|oo|\^[iI]|RR[iI]|L[iI]|~N|N\^|Ch|chh|JN|sh|Sh|\.a/

    # Match on SLP1-only characters and bigrams
    RE_SLP1_ONLY = /[fFxXEOCYwWqQPB]|kz|N[kg]|tT|dD|S[cn]|[aAiIuUeo]R|G[yr]/

    # Match on Velthuis-only characters
    RE_VELTHUIS_ONLY = /\.[mhnrlntds]|"n|~s/

    # Match on chars shared by ITRANS and Velthuis
    RE_ITRANS_OR_VELTHUIS_ONLY = /aa|ii|uu|~n/

    # Match on characters available in Harvard-Kyoto
    RE_HARVARD_KYOTO = /[aAiIuUeoRMHkgGcjJTDNtdnpbmyrlvzSsh]/

    # Match ##...## or {#...#} control blocks.
    RE_CONTROL_BLOCK = /(?<!\\)##.*?(?<!\\)##|(?<!\\)\{#.*?(?<!\\)#\}/

    private_constant :RE_BRAHMIC_RANGE, :BRAHMIC_SCRIPTS_ORDER, :RE_IAST_OR_KOLKATA_ONLY,
                     :RE_KOLKATA_ONLY, :RE_ITRANS_ONLY, :RE_SLP1_ONLY, :RE_VELTHUIS_ONLY,
                     :RE_ITRANS_OR_VELTHUIS_ONLY, :RE_HARVARD_KYOTO, :RE_CONTROL_BLOCK
  end
end
