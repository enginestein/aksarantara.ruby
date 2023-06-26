# frozen_string_literal: true

RSpec.shared_examples "text tests" do |from, to, options = {}|
  context "text tests" do
    it "Single word" do
      expect(described_class.transliterate(scheme_data[from][:putra], from, to, options))
        .to eq(scheme_data[to][:putra])
    end
    it "Two words, one with explicit vowel" do
      expect(described_class.transliterate(scheme_data[from][:naraIti], from, to, options))
        .to eq(scheme_data[to][:naraIti])
    end
    it "Basic sentence" do
      expect(described_class.transliterate(scheme_data[from][:sentence], from, to, options))
        .to eq(scheme_data[to][:sentence])
    end
  end
end
