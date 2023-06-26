# frozen_string_literal: true

RSpec.shared_examples "letter tests" do |from, to, options = {}|
  context "letter tests" do
    # If `from` vowels are missing ṛ ṝ ḷ ḹ relative to `to`, remove them
    # so that the test can pass.
    def equalize_vowels(from, to) # rubocop:disable AbcSize
      from_data = scheme_data[from][:vowels].strip.split(/\s+/)
      to_data = scheme_data[to][:vowels].strip.split(/\s+/)
      diff = from_data.count - to_data.count
      from_data.slice!(6, 4) if diff == 4
      [from_data.join(" "), to_data.join(" ")]
    end

    # If `from` marks are missing ṛ ṝ [ḷ ḹ] relative to `to`, remove them
    # so that the test can pass
    def equalize_marks(from, to) # rubocop:disable AbcSize
      from_data = scheme_data[from][:marks].strip.split(/\s+/)
      to_data = scheme_data[to][:marks].strip.split(/\s+/)
      diff = from_data.count - to_data.count
      if diff == 4
        from_data.slice!(6, 4)
      elsif diff == 2
        from_data.slice!(8, 2)
      end
      [from_data.join(" "), to_data.join(" ")]
    end

    it "Vowels" do
      data = equalize_vowels(from, to)
      expect(described_class.transliterate(data[0], from, to, options)).to eq(data[1])
    end
    it "Marks" do
      data = equalize_marks(from, to)
      expect(described_class.transliterate(data[0], from, to, options)).to eq(data[1])
    end
    it "Stops and nasals" do
      expect(described_class.transliterate(scheme_data[from][:consonants], from, to, options))
        .to eq(scheme_data[to][:consonants])
    end
    it "Other consonants" do
      expect(described_class.transliterate(scheme_data[from][:other], from, to, options))
        .to eq(scheme_data[to][:other])
    end
    it "Symbols and punctuation" do
      expect(described_class.transliterate(scheme_data[from][:symbols], from, to, options))
        .to eq(scheme_data[to][:symbols])
    end
  end
end
