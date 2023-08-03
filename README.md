# aksarantara.rb

Aksarantara is a powerful transliteration framework primarily designed for Sanskrit, with additional transliteration features for various Indian languages. It offers multiple versions tailored for different programming languages, making it highly adaptable and versatile.

# Installation

Add this in your gemfile:

```ruby
gem 'aksarantara'
```

And then execute:

```sh
$ bundle
```

# Usage

`transliterate()` function of Aksarantara takes three parameters which are `text`, `from` and `to`. `text` refers to the text being transliterated, `from` refers to the scheme of the text and `to` refers to the scheme text must be transliterated into.

```ruby
aksarantara.transliterate("वन्दे मातरम्", devnagri, hk)
```

Here the text `वन्दे मातरम्` is `devnagri` and being transliterated into `hk` (Harvard-Kyoto) scheme.

Aksarantara has following Brahmic and Abrahmic schemes:

- bengali
- devanagari
- gujarati
- gurmukhi
- kannada
- malayalam
- oriya
- tamil
- telugu
- hk (Harvard-Kyoto)
- iast (International Alphabet of Sanskrit Transliteration)
- itrans (ITRANS)
- itrans_dravidian (ITRANS with support for Dravidian short "e" and "o")
- kolkata (National Library at Kolkata)
- slp1 (Sanskrit Library Phonetic Basic)
- velthuis (Velthuis)
- wx (WX)

## Detecting 

To detect the scheme of text you can use `detect()` function

```ruby
aksarantara.detect("वन्दे मातरम्") # Devnagri
```

## Adding new schemes

to add Brahmic schemes:

```ruby
aksarantara.add_brahmic_scheme(name, scheme)
```

To add Abrahmic or Roman schemes:

```ruby
aksarantara.add_abrahmic_scheme()
```

More finrmation about Aksarantara is available in the [PHP version of Aksarantara](https://www.github.com/enginestein/aksarantara.php)
