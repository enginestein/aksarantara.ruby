require "spec_helper"

describe aksarantara::Benchmark do
  it { is_expected.to respond_to(:detect!) }
  it "benchmarks detection" do
    expect { described_class.detect!(0.1, 0) }.to output(/^Comparison\:$/).to_stdout
  end

  it { is_expected.to respond_to(:transliterate_roman!) }
  it "benchmarks roman-source transliteration" do
    expect { described_class.transliterate_roman!(0.1, 0) }.to output(/^Comparison\:$/).to_stdout
  end

  it { is_expected.to respond_to(:transliterate_brahmic!) }
  it "benchmarks brahmic-source transliteration" do
    expect { described_class.transliterate_brahmic!(0.1, 0) }.to output(/^Comparison\:$/).to_stdout
  end
end
