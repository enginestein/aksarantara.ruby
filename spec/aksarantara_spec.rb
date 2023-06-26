# frozen_string_literal: true

require "spec_helper"

describe aksarantara do
  it "has a version number" do
    expect(described_class::VERSION).not_to be nil
  end

  it "displays if Rust extension is available" do
    expect(described_class::RUST_AVAILABLE).not_to be nil
  end

  it "displays if Rust extension is enabled" do
    expect(described_class.rust_enabled?).not_to be nil
  end

  it "allows Rust extension to be disabled" do
    expect(described_class.rust_disable!).not_to be nil
  end

  it "allows Rust extension to be enabled" do
    expect(described_class.rust_enable!).not_to be nil
  end

  context ".detect" do
    it "returns the same result as Detect.detect_scheme" do
      expect(described_class.detect(scheme_data[:devanagari][:sentence]))
        .to eq(described_class::Detect.detect_scheme(scheme_data[:devanagari][:sentence]))
    end
  end

  context ".transliterate" do
    it "returns a result with source and destination scheme specified" do
      expect(described_class.transliterate(scheme_data[:devanagari][:sentence], :devanagari, :iast))
        .to eq(scheme_data[:iast][:sentence])
    end
    it "returns a result with source specified nil and destination scheme specified" do
      expect(described_class.transliterate(scheme_data[:devanagari][:sentence], nil, :iast))
        .to eq(scheme_data[:iast][:sentence])
    end
    it "returns a result with just destination scheme specified" do
      expect(described_class.transliterate(scheme_data[:devanagari][:sentence], :iast))
        .to eq(scheme_data[:iast][:sentence])
    end
    it "raises a DetectionError when it cannot detect the source scheme" do
      expect { described_class.transliterate("Z", :iast) }
        .to raise_error(described_class::DetectionError)
    end
  end
end
