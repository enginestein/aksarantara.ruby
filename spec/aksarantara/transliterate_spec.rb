# frozen_string_literal: true

require "spec_helper"

describe aksarantara::Transliterate do
  brahmic_schemes = %i[bengali devanagari gujarati gurmukhi kannada malayalam
                       oriya tamil telugu]
  roman_schemes = %i[hk kh iast itrans itrans_dravidian kolkata velthuis]
  all_schemes = brahmic_schemes + roman_schemes

  context ".schemes" do
    it { expect(described_class.schemes).to be_kind_of(Hash).and not_be_empty }
    all_schemes.each do |scheme|
      it { expect(described_class.schemes).to include(scheme) }
    end
  end

  context ".roman_scheme?" do
    all_schemes.each do |scheme|
      expectation = roman_schemes.include?(scheme) ? true : false
      desc = ":#{scheme} should be #{expectation}"
      it desc do
        expect(described_class.roman_scheme?(scheme)).to eq(expectation)
      end
    end
  end

  context ".brahmic_scheme?" do
    all_schemes.each do |scheme|
      expectation = brahmic_schemes.include?(scheme) ? true : false
      desc = ":#{scheme} should be #{expectation}"
      it desc do
        expect(described_class.brahmic_scheme?(scheme)).to eq(expectation)
      end
    end
  end

  context ".transliterate" do
    it "raises a SchemeNotSupported error if an unsupported source scheme is specified" do
      expect { described_class.transliterate("", :unknown, :hk) }
        .to raise_error(aksarantara::SchemeNotSupportedError)
    end
    it "raises a SchemeNotSupported error if an unsupported destination scheme is specified" do
      expect { described_class.transliterate("", :hk, :unknown) }
        .to raise_error(aksarantara::SchemeNotSupportedError)
    end
  end

  context "Devanagari" do
    from = :devanagari
    context "to Bengali" do
      to = :bengali
      include_examples("letter tests", from, to)
      include_examples("text tests", from, to)
      it "व transliteration" do
        expect(described_class.transliterate("व", from, to)).to eq("ব")
      end
      it "ब transliteration" do
        expect(described_class.transliterate("ब", from, to)).to eq("ব")
      end
    end

    context "to Gujarati" do
      to = :gujarati
      include_examples("letter tests", from, to)
      include_examples("text tests", from, to)
    end

    context "to Gurmukhi" do
      to = :gurmukhi
      include_examples("letter tests", from, to)
      include_examples("text tests", from, to)
    end

    context "to Kannada" do
      to = :kannada
      include_examples("letter tests", from, to)
      include_examples("text tests", from, to)
    end

    context "to Malayalam" do
      to = :malayalam
      include_examples("letter tests", from, to)
      include_examples("text tests", from, to)
    end

    context "to Oriya" do
      to = :oriya
      include_examples("letter tests", from, to)
      include_examples("text tests", from, to)
    end

    context "to Telugu" do
      to = :telugu
      include_examples("letter tests", from, to)
      include_examples("text tests", from, to)
    end

    context "to IAST" do
      to = :iast
      include_examples("letter tests", from, to)
      include_examples("text tests", from, to)
      it "Vowel among other letters" do
        expect(described_class.transliterate("wwॠww", from, to)).to eq("wwṝww")
      end
      it "Consonant among other letters" do
        expect(described_class.transliterate("wwटww", from, to)).to eq("wwṭaww")
      end
    end

    context "to Harvard-Kyoto" do
      to = :hk
      include_examples("letter tests", from, to)
      include_examples("text tests", from, to)
      it "Vowel among other letters" do
        expect(described_class.transliterate("wwॠww", from, to)).to eq("wwRRww")
      end
      it "Consonant among other letters" do
        expect(described_class.transliterate("wwकww", from, to)).to eq("wwkaww")
      end
    end

    context "to SLP1" do
      to = :slp1
      include_examples("letter tests", from, to)
      include_examples("text tests", from, to)
      it "Vowel among other letters" do
        expect(described_class.transliterate("ZZॠZZ", from, to)).to eq("ZZFZZ")
      end
      it "Consonant among other letters" do
        expect(described_class.transliterate("ZZटZZ", from, to)).to eq("ZZwaZZ")
      end
    end

    context "to ITRANS" do
      to = :itrans
      include_examples("letter tests", from, to)
      include_examples("text tests", from, to)
    end

    context "to Velthuis" do
      to = :velthuis
      include_examples("letter tests", from, to)
      include_examples("text tests", from, to)
    end
  end

  context "IAST" do
    from = :iast
    context "to Devanagari" do
      to = :devanagari
      include_examples("letter tests", from, to)
      include_examples("text tests", from, to)
      it "Undefined letters" do
        expect(described_class.transliterate("narīxiti", from, to)).to eq("नरीxइति")
      end
    end

    context "to Harvard-Kyoto" do
      to = :hk
      include_examples("letter tests", from, to)
      include_examples("text tests", from, to)
      it "Undefined letters" do
        expect(described_class.transliterate("tāmxiti", from, to)).to eq("tAmxiti")
      end
    end

    context "to SLP1" do
      to = :slp1
      include_examples("letter tests", from, to)
      include_examples("text tests", from, to)
      it "Undefined letters" do
        expect(described_class.transliterate("ṣauZiti", from, to)).to eq("zOZiti")
      end
    end

    context "to ITRANS" do
      to = :itrans
      include_examples("letter tests", from, to)
      include_examples("text tests", from, to)
    end

    context "to Velthuis" do
      to = :velthuis
      include_examples("letter tests", from, to)
      include_examples("text tests", from, to)
    end
  end

  context "Harvard-Kyoto" do
    from = :hk
    context "to Devanagari" do
      to = :devanagari
      include_examples("letter tests", from, to)
      include_examples("text tests", from, to)
      it "Undefined letters" do
        expect(described_class.transliterate("naraxiti", from, to)).to eq("नरxइति")
      end
    end

    context "to IAST" do
      to = :iast
      include_examples("letter tests", from, to)
      include_examples("text tests", from, to)
      it "Undefined letters" do
        expect(described_class.transliterate("tAmxiti", from, to)).to eq("tāmxiti")
      end
    end

    context "to SLP1" do
      to = :slp1
      include_examples("letter tests", from, to)
      include_examples("text tests", from, to)
      it "Undefined letters" do
        expect(described_class.transliterate("tauZiti", from, to)).to eq("tOZiti")
      end
    end

    context "to ITRANS" do
      to = :itrans
      include_examples("letter tests", from, to)
      include_examples("text tests", from, to)
    end

    context "to Velthuis" do
      to = :velthuis
      include_examples("letter tests", from, to)
      include_examples("text tests", from, to)
    end
  end

  context "SLP1" do
    from = :slp1
    context "to Devanagari" do
      to = :devanagari
      include_examples("letter tests", from, to)
      include_examples("text tests", from, to)
      it "Undefined letters" do
        expect(described_class.transliterate("narIZiti", from, to)).to eq("नरीZइति")
      end
    end

    context "to IAST" do
      to = :iast
      include_examples("letter tests", from, to)
      include_examples("text tests", from, to)
      it "Undefined letters" do
        expect(described_class.transliterate("zOZiti", from, to)).to eq("ṣauZiti")
      end
    end

    context "to Harvard-Kyoto" do
      to = :hk
      include_examples("letter tests", from, to)
      include_examples("text tests", from, to)
      it "Undefined letters" do
        expect(described_class.transliterate("RAmZiti", from, to)).to eq("NAmZiti")
      end
    end

    context "to ITRANS" do
      to = :itrans
      include_examples("letter tests", from, to)
      include_examples("text tests", from, to)
    end

    context "to Velthuis" do
      to = :velthuis
      include_examples("letter tests", from, to)
      include_examples("text tests", from, to)
    end
  end

  context "ITRANS" do
    from = :itrans
    context "to Devanagari" do
      to = :devanagari
      include_examples("letter tests", from, to)
      include_examples("text tests", from, to)
    end

    context "to IAST" do
      to = :iast
      include_examples("letter tests", from, to)
      include_examples("text tests", from, to)
    end

    context "to Harvard-Kyoto" do
      to = :hk
      include_examples("letter tests", from, to)
      include_examples("text tests", from, to)
    end

    context "to SLP1" do
      to = :slp1
      include_examples("letter tests", from, to)
      include_examples("text tests", from, to)
    end

    context "to Velthuis" do
      to = :velthuis
      include_examples("letter tests", from, to)
      include_examples("text tests", from, to)
    end
  end

  context "Velthuis" do
    from = :velthuis
    context "to Devanagari" do
      to = :devanagari
      include_examples("letter tests", from, to)
      include_examples("text tests", from, to)
    end

    context "to IAST" do
      to = :iast
      include_examples("letter tests", from, to)
      include_examples("text tests", from, to)
    end

    context "to Harvard-Kyoto" do
      to = :hk
      include_examples("letter tests", from, to)
      include_examples("text tests", from, to)
    end

    context "to SLP1" do
      to = :slp1
      include_examples("letter tests", from, to)
      include_examples("text tests", from, to)
    end

    context "to ITRANS" do
      to = :itrans
      include_examples("letter tests", from, to)
      include_examples("text tests", from, to)
    end
  end

  context "Control blocks" do
    context "aksarantara style: From Brahmic" do
      to = :hk
      from = :devanagari
      it "Basic Disable" do
        expect(described_class.transliterate("अ##क्ष##र", from, to)).to eq("aक्षra")
      end
      it "Initial disable" do
        expect(described_class.transliterate("##अ##क्षर", from, to)).to eq("अkSara")
      end
      it "Final disable 1" do
        expect(described_class.transliterate("अक्ष##र##", from, to)).to eq("akSaर")
      end
      it "Final disable 2" do
        expect(described_class.transliterate("अक्ष##र", from, to)).to eq("akSaर")
      end
      it "Redundant disable 1" do
        expect(described_class.transliterate("अक्ष##र####", from, to)).to eq("akSaर")
      end
      it "Redundant disable 2" do
        expect(described_class.transliterate("अ####क्षर", from, to)).to eq("akSara")
      end
      it "Misleading disable" do
        expect(described_class.transliterate("अ#क्षर", from, to)).to eq("a#kSara")
      end
    end

    context "aksarantara style: From roman" do
      to = :devanagari
      from = :hk
      it "Basic Disable" do
        expect(described_class.transliterate("akSa##kSa##ra", from, to)).to eq("अक्षkSaर")
      end
      it "Initial disable" do
        expect(described_class.transliterate("##akSa##kSa##ra", from, to)).to eq("akSaक्षra")
      end
      it "Final disable 1" do
        expect(described_class.transliterate("akSa##ra##", from, to)).to eq("अक्षra")
      end
      it "Final disable 2" do
        expect(described_class.transliterate("akSa##ra", from, to)).to eq("अक्षra")
      end
      it "Redundant disable 1" do
        expect(described_class.transliterate("akSa##kSa##ra####", from, to)).to eq("अक्षkSaर")
      end
      it "Redundant disable 2" do
        expect(described_class.transliterate("a####kSara", from, to)).to eq("अक्षर")
      end
      it "Misleading disable" do
        expect(described_class.transliterate("a#kSara", from, to)).to eq("अ#क्षर")
      end
    end

    context "Dphil style: From Brahmic" do
      to = :hk
      from = :devanagari
      it "Basic Disable" do
        expect(described_class.transliterate("अ{#क्ष#}र", from, to)).to eq("a{#क्ष#}ra")
      end
      it "Initial disable" do
        expect(described_class.transliterate("{#अ#}क्षर", from, to)).to eq("{#अ#}kSara")
      end
      it "Final disable 1" do
        expect(described_class.transliterate("अक्ष{#र#}", from, to)).to eq("akSa{#र#}")
      end
      it "Final disable 2" do
        expect(described_class.transliterate("अक्ष{#र", from, to)).to eq("akSa{#र")
      end
      it "Redundant disable 1" do
        expect(described_class.transliterate("अक्ष{#र#}{#", from, to)).to eq("akSa{#र#}{#")
      end
      it "Redundant disable 2" do
        expect(described_class.transliterate("अ{##}क्षर", from, to)).to eq("a{##}kSara")
      end
      it "Misleading disable" do
        expect(described_class.transliterate("अ{क्षर", from, to)).to eq("a{kSara")
      end
    end

    context "Dphil style: From roman" do
      to = :devanagari
      from = :hk
      it "Basic Disable" do
        expect(described_class.transliterate("akSa{#kSa#}ra", from, to)).to eq("अक्ष{#kSa#}र")
      end
      it "Initial disable" do
        expect(described_class.transliterate("{#akSa#}kSa{#ra", from, to)).to eq("{#akSa#}क्ष{#ra")
      end
      it "Final disable 1" do
        expect(described_class.transliterate("akSa{#ra#}", from, to)).to eq("अक्ष{#ra#}")
      end
      it "Final disable 2" do
        expect(described_class.transliterate("akSa{#ra", from, to)).to eq("अक्ष{#ra")
      end
      it "Redundant disable 1" do
        expect(described_class.transliterate("akSa{#kSa#}ra{##}", from, to)).to eq("अक्ष{#kSa#}र{##}")
      end
      it "Redundant disable 2" do
        expect(described_class.transliterate("a{##}kSara", from, to)).to eq("अ{##}क्षर")
      end
      it "Misleading disable" do
        expect(described_class.transliterate("a{kSara", from, to)).to eq("अ{क्षर")
      end
    end
  end
end
