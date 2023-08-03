
require "aksarantara/transliterate/schemes"
module aksarantara
  module Transliterate
    class << self
      attr_reader :scheme_names
      attr_reader :brahmic_schemes
      attr_reader :roman_schemes
      attr_reader :schemes
      attr_reader :all_alternates
      attr_reader :defaults
    end

    @defaults = {
      skip_sgml: false,
      syncope: false,
    }

    @cache = {}

    module_function

    def brahmic_scheme?(name)
      @brahmic_schemes.include?(name.to_sym)
    end

    def abrahmic_scheme?(name)
      @roman_schemes.include?(name.to_sym)
    end

    def add_brahmic_scheme(name, scheme)
      name = name.to_sym
      scheme = scheme.deep_dup
      @schemes[name] = IceNine.deep_freeze(scheme)
      @brahmic_schemes.add(name)
      @scheme_names.add(name)
      scheme
    end

    def add_abrahmic_scheme(name, scheme)
      name = name.to_sym
      scheme = scheme.deep_dup
      scheme[:vowel_marks] = scheme[:vowels][1..-1] unless scheme.key?(:vowel_marks)
      @schemes[name] = IceNine.deep_freeze(scheme)
      @roman_schemes.add(name)
      @scheme_names.add(name)
      scheme
    end

    begin
      brahmic_scheme_names = %i[bengali devanagari gujarati gurmukhi kannada malayalam
                                oriya tamil telugu]
      brahmic_scheme_names.each do |name|
        add_brahmic_scheme(name, @schemes[name])
      end

      kolkata = @schemes[:kolkata] = @schemes[:iast].deep_dup
      roman_scheme_names = %i[iast itrans hk kolkata slp1 velthuis wx]
      kolkata[:vowels] = %w[a ā i ī u ū ṛ ṝ ḷ ḹ e ē ai o ō au]

      roman_scheme_names.each do |name|
        add_abrahmic_scheme(name, @schemes[name])
      end

      add_abrahmic_scheme(:kh, @schemes[:hk])
      itrans_dravidian = @schemes[:itrans].deep_dup
      itrans_dravidian[:vowels] = %w[a A i I u U Ri RRI LLi LLi e E ai o O au]
      itrans_dravidian[:vowel_marks] = itrans_dravidian[:vowels][1..-1]
      @all_alternates[:itrans_dravidian] = @all_alternates[:itrans]
      add_abrahmic_scheme(:itrans_dravidian, itrans_dravidian)
      @all_alternates.each_value { |alternates| IceNine.deep_freeze(alternates) }
    end

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

              if group == :vowel_marks || group == :virama 
                marks[f] = t
                alts.each { |alt| marks[alt] = t }
              else
                letters[f] = t
                alts.each { |alt| letters[alt] = t }

                if group == :consonants || group == :other 
                  consonants[f] = t
                  alts.each { |alt| consonants[alt] = t }
                end
              end
            end
          end

          IceNine.deep_freeze(
            consonants: consonants,
            from_roman?: abrahmic_scheme?(from),
            letters: letters,
            marks: marks,
            max_token_length: token_lengths.max,
            to_roman?: abrahmic_scheme?(to),
            virama: to_scheme[:virama].first
          )
        end
      end
      def transliterate_roman(data, map, options = {})
        data = data.to_str.chars
        buf = []
        token_buffer = []
        had_consonant = false
        transliteration_enabled = true
        control_char = false
        max_token_length = map[:max_token_length]

        until data.empty? && token_buffer.empty?
          token = data[0, max_token_length].join("")
          max_token_length.downto(1) do |j|
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
                if had_consonant
                  if (temp_mark = map[:marks][token])
                    buf << temp_mark
                  elsif token != "a"
                    buf.push(map[:virama], temp_letter)
                  end
                else
                  buf << temp_letter
                end
                had_consonant = map[:consonants].key?(token)
              end
              j > 1 ? data.shift(j) : data.shift
              break
            elsif j == 1 
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
  end
end
