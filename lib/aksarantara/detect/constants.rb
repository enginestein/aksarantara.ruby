# frozen_string_literal: true

module aksarantara
  module Detect
    RE_BRAHMIC_RANGE = /[\u0900-\u0d7f]/
    BRAHMIC_SCRIPTS_ORDER = %i[devanagari bengali gurmukhi gujarati oriya tamil telugu kannada malayalam].freeze
    RE_IAST_OR_KOLKATA_ONLY = /[āīūṛṝḷḹēōṃḥṅñṭḍṇśṣḻĀĪŪṚṜḶḸĒŌṂḤṄÑṬḌṆŚṢḺ]|
                               [aiueoAIUEO]\u0304|[rlRL]\u0323\u0304?|
                               [mhtdMHTD]\u0323|[nN][\u0307\u0303\u0323]|
                               [sS][\u0301\u0323]|[lL]\u0331/x

    RE_KOLKATA_ONLY = /[ēōĒŌ]|[eoEO]\u0304/
    RE_ITRANS_ONLY = /ee|oo|\^[iI]|RR[iI]|L[iI]|~N|N\^|Ch|chh|JN|sh|Sh|\.a/
    RE_SLP1_ONLY = /[fFxXEOCYwWqQPB]|kz|N[kg]|tT|dD|S[cn]|[aAiIuUeo]R|G[yr]/
    RE_VELTHUIS_ONLY = /\.[mhnrlntds]|"n|~s/
    RE_ITRANS_OR_VELTHUIS_ONLY = /aa|ii|uu|~n/
    RE_HARVARD_KYOTO = /[aAiIuUeoRMHkgGcjJTDNtdnpbmyrlvzSsh]/
    RE_CONTROL_BLOCK = /(?<!\\)##.*?(?<!\\)##|(?<!\\)\{#.*?(?<!\\)#\}/

    private_constant :RE_BRAHMIC_RANGE, :BRAHMIC_SCRIPTS_ORDER, :RE_IAST_OR_KOLKATA_ONLY,
                     :RE_KOLKATA_ONLY, :RE_ITRANS_ONLY, :RE_SLP1_ONLY, :RE_VELTHUIS_ONLY,
                     :RE_ITRANS_OR_VELTHUIS_ONLY, :RE_HARVARD_KYOTO, :RE_CONTROL_BLOCK
  end
end
