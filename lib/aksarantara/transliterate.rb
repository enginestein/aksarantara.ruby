# frozen_string_literal: true

require "aksarantara/transliterate/schemes"
module aksarantara
  # Sanskrit transliteration module.
  # Derived from aksarantara (https://github.com/sanskrit/aksarantara.js), which is
  # released under the MIT and GPL Licenses.
  #
  # "aksarantara is a Sanskrit transliteration library. Currently, it supports
  # other Indian languages only incidentally."
  module Transliterate
    class << self
      # @return [Array<Symbol>] the names of all supported schemes
      attr_reader :scheme_names

      # @return [Array<Symbol>] the names of all Brahmic schemes
      attr_reader :brahmic_schemes

      # @return [Array<Symbol>] the names of all roman schemes
      attr_reader :roman_schemes

      # @return [Hash] the data for all schemes
      attr_reader :schemes

      # @return [Hash] the alternate-character data for all schemes
      attr_reader :all_alternates

      # @return [Hash] the default transliteration options
      attr_reader :defaults
    end

    @defaults = {
      skip_sgml: false,
      syncope: false,
    }

    @cache = {}

    module_function

    # rubocop:disable AbcSize, CyclomaticComplexity, MethodLength, PerceivedComplexity

    # Check whether the given scheme encodes Brahmic Sanskrit.
    #
    # @param name [Symbol] the scheme name
    # @return [Boolean]
    def brahmic_scheme?(name)
      @brahmic_schemes.include?(name.to_sym)
    end

    #  Check whether the given scheme encodes romanized Sanskrit.
    #
    #  @param name [Symbol] the scheme name
    #  @return [Boolean]
    def roman_scheme?(name)
      @roman_schemes.include?(name.to_sym)
    end

    # Add a Brahmic scheme to aksarantara.
    #
    # Schemes are of two types: "Brahmic" and "roman". Brahmic consonants
    # have an inherent vowel sound, but roman consonants do not. This is the
    # main difference between these two types of scheme.
    #
    # A scheme definition is a Hash that maps a group name to a
    # list of characters. For illustration, see `transliterate/schemes.rb`.
    #
    # You can use whatever group names you like, but for the best results,
    # you should use the same group names that aksarantara does.
    #
    # @param name [Symbol] the scheme name
    # @param scheme [Hash] the scheme data, constructed as described above
    # @return [Hash] the frozen scheme data as it exists inside the module
    def add_brahmic_scheme(name, scheme)
      name = name.to_sym
      scheme = scheme.deep_dup
      @schemes[name] = IceNine.deep_freeze(scheme)
      @brahmic_schemes.add(name)
      @scheme_names.add(name)
      scheme
    end

    # Add a roman scheme to aksarantara.
    #
    # @param name [Symbol] the scheme name
    # @param scheme [Hash] the scheme data, constructed as in {add_brahmic_scheme}.
    #                      The "vowel_marks" field can be omitted
    # @return [Hash] the frozen scheme data as it exists inside the module
    def add_roman_scheme(name, scheme)
      name = name.to_sym
      scheme = scheme.deep_dup
      scheme[:vowel_marks] = scheme[:vowels][1..-1] unless scheme.key?(:vowel_marks)
      @schemes[name] = IceNine.deep_freeze(scheme)
      @roman_schemes.add(name)
      @scheme_names.add(name)
      scheme
    end

    # Set up various schemes
    begin
      # Re-add existing Brahmic schemes in order to add them to `scheme_names`
      # and to freeze them up.
      brahmic_scheme_names = %i[bengali devanagari gujarati gurmukhi kannada malayalam
                                oriya tamil telugu]
      brahmic_scheme_names.each do |name|
        add_brahmic_scheme(name, @schemes[name])
      end

      # Set up roman schemes
      kolkata = @schemes[:kolkata] = @schemes[:iast].deep_dup
      roman_scheme_names = %i[iast itrans hk kolkata slp1 velthuis wx]
      kolkata[:vowels] = %w[a ā i ī u ū ṛ ṝ ḷ ḹ e ē ai o ō au]

      # These schemes already belong to aksarantara.schemes. But by adding
      # them again with `add_roman_scheme`, we automatically build up
      # `roman_schemes` and define a `vowel_marks` field for each one.
      roman_scheme_names.each do |name|
        add_roman_scheme(name, @schemes[name])
      end

      # Add Kyoto-Harvard copy (alternate name of Harvard-Kyoto scheme)/
      add_roman_scheme(:kh, @schemes[:hk])

      # ITRANS variant, which supports Dravidian short 'e' and 'o'.
      itrans_dravidian = @schemes[:itrans].deep_dup
      itrans_dravidian[:vowels] = %w[a A i I u U Ri RRI LLi LLi e E ai o O au]
      itrans_dravidian[:vowel_marks] = itrans_dravidian[:vowels][1..-1]
      @all_alternates[:itrans_dravidian] = @all_alternates[:itrans]
      add_roman_scheme(:itrans_dravidian, itrans_dravidian)

      # ensure deep freeze on alternates
      @all_alternates.each_value { |alternates| IceNine.deep_freeze(alternates) }
    end

    # Transliterate from one script to another.
    #
    # @param data [String] the String to transliterate
    # @param from [Symbol] the source script
    # @param to [Symbol] the destination script
    # @option opts [Boolean] :skip_sgml (false) escape SGML-style tags in text string
    # @option opts [Boolean] :syncope (false) activate Hindi-style schwa syncope
    # @return [String] the transliterated string
    def transliterate(data, from, to, **opts)
      from = from.to_sym
      to = to.to_sym
      return data if from == to
      raise SchemeNotSupportedError, from unless @schemes.key?(from)
      raise SchemeNotSupportedError, to unless @schemes.key?(to)

      data = data.to_str.dup
      options = @defaults.merge(opts)
      map = make_map(from, to)

      data.gsub!(/(<.*?>)/, "##\\1##") if options[:skip_sgml]

      # Easy way out for "{\m+}", "\", and ".h".
      if from == :itrans
        data.gsub!(/\{\\m\+\}/, ".h.N")
        data.gsub!(/\.h/, "")
        data.gsub!(/\\([^'`_]|$)/, "##\\1##")
      end

      if map[:from_roman?]
        transliterate_roman(data, map, options)
      else
        transliterate_brahmic(data, map)
      end
    end

    class << self
      private

      # Create a map from every character in `from` to its partner in `to`.
      # Also, store any "marks" that `from` might have.
      #
      # @param from [Symbol] name of input scheme
      # @param to [Symbol] name of output scheme
      # @return [Hash] a mapping from one scheme to another
      def make_map(from, to)
        @cache[:"#{from}_#{to}"] ||= begin
          alternates = @all_alternates[from] || {}
          consonants = {}
          from_scheme = @schemes[from]
          letters = {}
          token_lengths = []
          marks = {}
          to_scheme = @schemes[to]

          from_scheme.each do |group, from_group|
            to_group = to_scheme[group]
            next if to_group.nil?

            from_group.each_with_index do |f, i|
              t = to_group[i]
              alts = alternates[f] || []
              token_lengths.push(f.length)
              token_lengths.concat(alts.map(&:length))

              if group == :vowel_marks || group == :virama # rubocop:disable MultipleComparison
                marks[f] = t
                alts.each { |alt| marks[alt] = t }
              else
                letters[f] = t
                alts.each { |alt| letters[alt] = t }

                if group == :consonants || group == :other # rubocop:disable MultipleComparison
                  consonants[f] = t
                  alts.each { |alt| consonants[alt] = t }
                end
              end
            end
          end

          IceNine.deep_freeze(
            consonants: consonants,
            from_roman?: roman_scheme?(from),
            letters: letters,
            marks: marks,
            max_token_length: token_lengths.max,
            to_roman?: roman_scheme?(to),
            virama: to_scheme[:virama].first
          )
        end
      end

      # Transliterate from a romanized script.
      #
      # @param data [String] the string to transliterate
      # @param map [Hash] map data generated from {#make_map}
      # @return [String] the transliterated string
      def transliterate_roman(data, map, options = {})
        data = data.to_str.chars
        buf = []
        token_buffer = []
        had_consonant = false
        transliteration_enabled = true
        control_char = false
        max_token_length = map[:max_token_length]

        until data.empty? && token_buffer.empty?
          # Match all token substrings to our map.
          token = data[0, max_token_length].join("")
          max_token_length.downto(1) do |j| # rubocop:disable BlockLength
            token = token[0, j] unless j == max_token_length
            if j == 2
              if !control_char && token == "##"
                transliteration_enabled = !transliteration_enabled
                data.shift(2)
                break
              elsif control_char && token == "#}"
                transliteration_enabled = true
                control_char = false
                buf << token
                data.shift(2)
                break
              elsif transliteration_enabled && token == "{#"
                transliteration_enabled = false
                control_char = true
                buf << token
                data.shift(2)
                break
              end
            end

            if transliteration_enabled && (temp_letter = map[:letters][token])
              if map[:to_roman?]
                buf << temp_letter
              else
                # Handle the implicit vowel. Ignore 'a' and force
                # vowels to appear as marks if we've just seen a
                # consonant.
                if had_consonant
                  # rubocop:disable Metrics/BlockNesting
                  if (temp_mark = map[:marks][token])
                    buf << temp_mark
                  elsif token != "a"
                    buf.push(map[:virama], temp_letter)
                  end
                  # rubocop:enable Metrics/BlockNesting
                else
                  buf << temp_letter
                end
                had_consonant = map[:consonants].key?(token)
              end
              j > 1 ? data.shift(j) : data.shift
              break
            elsif j == 1 # Last iteration
              if had_consonant
                had_consonant = false
                buf << map[:virama] unless options[:syncope]
              end
              buf << token
              data.shift
            end
          end
        end
        buf << map[:virama] if had_consonant && !options[:syncope]
        buf.join("")
      end

      # Transliterate from a Brahmic script.
      #
      # @param data [String] the string to transliterate
      # @param map [Hash] map data generated from {#make_map}
      # @return [String] the transliterated string
      def transliterate_brahmic(data, map)
        data = data.to_str.chars
        buf = []
        had_roman_consonant = false
        transliteration_enabled = true
        control_char = false

        until data.empty?
          token = data[0, 2].join("")
          if !control_char && token == "##"
            if had_roman_consonant
              buf << "a" if transliteration_enabled
              had_roman_consonant = false
            end
            transliteration_enabled = !transliteration_enabled
            data.shift(2)
            next
          elsif control_char && token == "#}"
            transliteration_enabled = true
            control_char = false
            buf << token
            data.shift(2)
            next
          elsif transliteration_enabled && token == "{#"
            if had_roman_consonant
              buf << "a"
              had_roman_consonant = false
            end
            transliteration_enabled = false
            control_char = true
            buf << token
            data.shift(2)
            next
          end

          l = data.shift
          unless transliteration_enabled
            buf << l
            next
          end

          temp = map[:marks][l]
          if !temp.nil?
            buf << temp
            had_roman_consonant = false
          else
            if had_roman_consonant
              buf << "a"
              had_roman_consonant = false
            end

            # Push transliterated letter if possible. Otherwise, push
            # the letter itself.
            temp = map[:letters][l]
            if !temp.nil?
              buf << temp
              had_roman_consonant = map[:to_roman?] && map[:consonants].key?(l)
            else
              buf << l
            end
          end
        end

        buf << "a" if had_roman_consonant
        buf.join("")
      end
    end
    # rubocop:enable AbcSize, CyclomaticComplexity, MethodLength, PerceivedComplexity
  end
end
