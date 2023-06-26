# frozen_string_literal: true

module aksarantara
  begin
    require "benchmark/ips"
  rescue LoadError
    #:nocov:
    module ::Benchmark # rubocop:disable Style/ClassAndModuleChildren
      def self.ips(*)
        raise NotImplementedError, "You must install the `benchmark-ips` gem first."
      end
    end
    #:nocov:
  end

  # Benchmark/testing module.
  module Benchmark
    TEST_STRINGS = {
      brahmic: {
        devanagari: "नानाशास्त्रसुभाषितामृतरसैः श्रोत्रोत्सवं कुर्वतां येषां यान्ति दिनानि " \
                    "पण्डितजनव्यायामखिन्नात्मनाम् तेषां जन्म च जीवितं च सुकृतं तैर् एव भूर् " \
                    "भूषिता शेषैह् किं पशुवद् विवेकरहितैर् भूभारभूतैर् नरः",
        malayalam: "നാനാശാസ്ത്രസുഭാഷിതാമൃതരസൈഃ ശ്രോത്രോത്സവം കുര്വതാം " \
                   "യേഷാം യാന്തി ദിനാനി പണ്ഡിതജനവ്യായാമഖിന്നാത്മനാമ് " \
                   "തേഷാം ജന്മ ച ജീവിതം ച സുകൃതം തൈര് ഏവ ഭൂര് ഭൂഷിതാ " \
                   "ശേഷൈഹ് കിം പശുവദ് വിവേകരഹിതൈര് ഭൂഭാരഭൂതൈര് നരഃ",
      }.freeze,
      roman: {
        iast: "nānāśāstrasubhāṣitāmṛtarasaiḥ śrotrotsavaṃ kurvatāṃ yeṣāṃ " \
              "yānti dināni paṇḍitajanavyāyāmakhinnātmanām teṣāṃ janma ca " \
              "jīvitaṃ ca sukṛtaṃ tair eva bhūr bhūṣitā śeṣaih kiṃ paśuvad " \
              "vivekarahitair bhūbhārabhūtair naraḥ",
        slp1: "nAnASAstrasuBAzitAmftarasEH SrotrotsavaM kurvatAM yezAM yAnti " \
              "dinAni paRqitajanavyAyAmaKinnAtmanAm tezAM janma ca jIvitaM " \
              "ca sukftaM tEr eva BUr BUzitA SezEh kiM paSuvad vivekarahitEr " \
              "BUBAraBUtEr naraH",
        hk: "nAnAzAstrasubhASitAmRtarasaiH zrotrotsavaM kurvatAM yeSAM yAnti " \
            "dinAni paNDitajanavyAyAmakhinnAtmanAm teSAM janma ca jIvitaM ca " \
            "sukRtaM tair eva bhUr bhUSitA zeSaih kiM pazuvad vivekarahitair " \
            "bhUbhArabhUtair naraH",
      }.freeze,
    }.freeze

    TEST_STRINGS_FLAT = TEST_STRINGS.reduce({}) { |a, (_, v)| a.merge(v) }.freeze

    private_constant :TEST_STRINGS, :TEST_STRINGS_FLAT

    module_function

    # Runs benchmark-ips test on detection methods.
    def detect!(time = 2, warmup = 1)
      ::Benchmark.ips do |x|
        x.config(time: time, warmup: warmup)
        TEST_STRINGS_FLAT.each do |scheme, string|
          x.report("Detect #{scheme}") do
            aksarantara::Detect.detect_scheme(string)
          end
        end
        x.compare!
      end
      true
    end

    # Runs benchmark-ips test on roman-source transliteration methods.
    def transliterate_roman!(time = 2, warmup = 1)
      ::Benchmark.ips do |x|
        x.config(time: time, warmup: warmup)
        TEST_STRINGS[:roman].to_a.product(TEST_STRINGS_FLAT.keys).each do |(ak, av), bk|
          next if ak == bk
          x.report("#{ak} => #{bk}") do
            aksarantara.transliterate(av, ak, bk)
          end
        end
        x.compare!
      end
      true
    end

    # Runs benchmark-ips test on brahmic-source transliteration methods.
    def transliterate_brahmic!(time = 2, warmup = 1)
      ::Benchmark.ips do |x|
        x.config(time: time, warmup: warmup)
        TEST_STRINGS[:brahmic].to_a.product(TEST_STRINGS_FLAT.keys).each do |(ak, av), bk|
          next if ak == bk
          x.report("#{ak} => #{bk}") do
            aksarantara.transliterate(av, ak, bk)
          end
        end
        x.compare!
      end
      true
    end
  end
end
