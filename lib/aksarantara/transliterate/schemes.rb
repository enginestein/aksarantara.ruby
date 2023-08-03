module aksarantara
  module Transliterate
    @schemes = {

      bengali: {
        vowels: "অ আ ই ঈ উ ঊ ঋ ৠ ঌ ৡ  এ ঐ  ও ঔ".split(/\s/),
        vowel_marks: "া ি ী ু ূ ৃ ৄ ৢ ৣ  ে ৈ  ো ৌ".split(/\s/),
        other_marks: "ং ঃ ঁ".split(/\s/),
        virama: ["্"],
        consonants: "ক খ গ ঘ ঙ চ ছ জ ঝ ঞ ট ঠ ড ঢ ণ ত থ দ ধ ন " \
                    "প ফ ব ভ ম য র ল ব শ ষ স হ ळ ক্ষ জ্ঞ".split(/\s/),
        symbols: "০ ১ ২ ৩ ৪ ৫ ৬ ৭ ৮ ৯ ॐ ঽ । ॥".split(/\s/),
        other: "    ড ঢ  য ".split(/\s/),
      },

      devanagari: {
        vowels: "अ आ इ ई उ ऊ ऋ ॠ ऌ ॡ ऎ ए ऐ ऒ ओ औ".split(/\s/),
        vowel_marks: "ा ि ी ु ू ृ ॄ ॢ ॣ ॆ े ै ॊ ो ौ".split(/\s/),
        other_marks: "ं ः ँ".split(/\s/),
        virama: ["्"],
        consonants: "क ख ग घ ङ च छ ज झ ञ ट ठ ड ढ ण त थ द ध न " \
                    "प फ ब भ म य र ल व श ष स ह ळ क्ष ज्ञ".split(/\s/),

        
        symbols: "० १ २ ३ ४ ५ ६ ७ ८ ९ ॐ ऽ । ॥".split(/\s/),
        zwj: ["\u200D"],
        skip: [""],
        accent: %W[\u0951 \u0952],
        combo_accent: "ः॑ ः॒ ं॑ ं॒".split(/\s/),
        candra: ["ॅ"],
        other: "क़ ख़ ग़ ज़ ड़ ढ़ फ़ य़ ऱ".split(/\s/),
      },

      gujarati: {
        vowels: "અ આ ઇ ઈ ઉ ઊ ઋ ૠ ઌ ૡ  એ ઐ  ઓ ઔ".split(/\s/),
        vowel_marks: "ા િ ી ુ ૂ ૃ ૄ ૢ ૣ  ે ૈ  ો ૌ".split(/\s/),
        other_marks: "ં ઃ ઁ".split(/\s/),
        virama: ["્"],
        consonants: "ક ખ ગ ઘ ઙ ચ છ જ ઝ ઞ ટ ઠ ડ ઢ ણ ત થ દ ધ ન " \
                    "પ ફ બ ભ મ ય ર લ વ શ ષ સ હ ળ ક્ષ જ્ઞ".split(/\s/),
        symbols: "૦ ૧ ૨ ૩ ૪ ૫ ૬ ૭ ૮ ૯ ૐ ઽ ૤ ૥".split(/\s/),
        candra: ["ૅ"],
      },

      gurmukhi: {
        vowels: "ਅ ਆ ਇ ਈ ਉ ਊ      ਏ ਐ  ਓ ਔ".split(/\s/),
        vowel_marks: "ਾ ਿ ੀ ੁ ੂ      ੇ ੈ  ੋ ੌ".split(/\s/),
        other_marks: "ਂ ਃ ਁ".split(/\s/),
        virama: ["੍"],
        consonants: "ਕ ਖ ਗ ਘ ਙ ਚ ਛ ਜ ਝ ਞ ਟ ਠ ਡ ਢ ਣ ਤ ਥ ਦ ਧ ਨ " \
                    "ਪ ਫ ਬ ਭ ਮ ਯ ਰ ਲ ਵ ਸ਼ ਸ਼ ਸ ਹ ਲ਼ ਕ੍ਸ਼ ਜ੍ਞ".split(/\s/),
        symbols: "੦ ੧ ੨ ੩ ੪ ੫ ੬ ੭ ੮ ੯ ॐ ऽ । ॥".split(/\s/),
        other: " ਖ ਗ ਜ ਡ  ਫ  ".split(/\s/),
      },

      kannada: {
        vowels: "ಅ ಆ ಇ ಈ ಉ ಊ ಋ ೠ ಌ ೡ ಎ ಏ ಐ ಒ ಓ ಔ".split(/\s/),
        vowel_marks: "ಾ ಿ ೀ ು ೂ ೃ ೄ ೢ ೣ ೆ ೇ ೈ ೊ ೋ ೌ".split(/\s/),
        other_marks: "ಂ ಃ ँ".split(/\s/),
        virama: ["್"],
        consonants: "ಕ ಖ ಗ ಘ ಙ ಚ ಛ ಜ ಝ ಞ ಟ ಠ ಡ ಢ ಣ ತ ಥ ದ ಧ ನ " \
                    "ಪ ಫ ಬ ಭ ಮ ಯ ರ ಲ ವ ಶ ಷ ಸ ಹ ಳ ಕ್ಷ ಜ್ಞ".split(/\s/),
        symbols: "೦ ೧ ೨ ೩ ೪ ೫ ೬ ೭ ೮ ೯ ಓಂ ಽ । ॥".split(/\s/),
        other: "      ಫ  ಱ".split(/\s/),
      },


      malayalam: {
        vowels: "അ ആ ഇ ഈ ഉ ഊ ഋ ൠ ഌ ൡ എ ഏ ഐ ഒ ഓ ഔ".split(/\s/),
        vowel_marks: "ാ ി ീ ു ൂ ൃ ൄ ൢ ൣ െ േ ൈ ൊ ോ ൌ".split(/\s/),
        other_marks: "ം ഃ ँ".split(/\s/),
        virama: ["്"],
        consonants: "ക ഖ ഗ ഘ ങ ച ഛ ജ ഝ ഞ ട ഠ ഡ ഢ ണ ത ഥ ദ ധ ന " \
                    "പ ഫ ബ ഭ മ യ ര ല വ ശ ഷ സ ഹ ള ക്ഷ ജ്ഞ".split(/\s/),
        symbols: "൦ ൧ ൨ ൩ ൪ ൫ ൬ ൭ ൮ ൯ ഓം ഽ । ॥".split(/\s/),
        other: "        റ".split(/\s/),
      },

    
      oriya: {
        vowels: "ଅ ଆ ଇ ଈ ଉ ଊ ଋ ୠ ଌ ୡ  ଏ ଐ  ଓ ଔ".split(/\s/),
        vowel_marks: "ା ି ୀ ୁ ୂ ୃ ୄ ୢ ୣ  େ ୈ  ୋ ୌ".split(/\s/),
        other_marks: "ଂ ଃ ଁ".split(/\s/),
        virama: ["୍"],
        consonants: "କ ଖ ଗ ଘ ଙ ଚ ଛ ଜ ଝ ଞ ଟ ଠ ଡ ଢ ଣ ତ ଥ ଦ ଧ ନ " \
                    "ପ ଫ ବ ଭ ମ ଯ ର ଲ ଵ ଶ ଷ ସ ହ ଳ କ୍ଷ ଜ୍ଞ".split(/\s/),
        symbols: "୦ ୧ ୨ ୩ ୪ ୫ ୬ ୭ ୮ ୯ ଓଂ ଽ । ॥".split(/\s/),
        other: "    ଡ ଢ  ଯ ".split(/\s/),
      },

      tamil: {
        vowels: "அ ஆ இ ஈ உ ஊ     எ ஏ ஐ ஒ ஓ ஔ".split(/\s/),
        vowel_marks: "ா ி ீ ு ூ     ெ ே ை ொ ோ ௌ".split(/\s/),
        other_marks: "ஂ ஃ ".split(/\s/),
        virama: ["்"],
        consonants: "க க க க ங ச ச ஜ ச ஞ ட ட ட ட ண த த த த ந " \
                    "ப ப ப ப ம ய ர ல வ ஶ ஷ ஸ ஹ ள க்ஷ ஜ்ஞ".split(/\s/),
        symbols: "௦ ௧ ௨ ௩ ௪ ௫ ௬ ௭ ௮ ௯ ௐ ऽ । ॥".split(/\s/),
        other: "        ற".split(/\s/),
      },
      
      telugu: {
        vowels: "అ ఆ ఇ ఈ ఉ ఊ ఋ ౠ ఌ ౡ ఎ ఏ ఐ ఒ ఓ ఔ".split(/\s/),
        vowel_marks: "ా ి ీ ు ూ ృ ౄ ౢ ౣ ె ే ై ొ ో ౌ".split(/\s/),
        other_marks: "ం ః ఁ".split(/\s/),
        virama: ["్"],
        consonants: "క ఖ గ ఘ ఙ చ ఛ జ ఝ ఞ ట ఠ డ ఢ ణ త థ ద ధ న " \
                    "ప ఫ బ భ మ య ర ల వ శ ష స హ ళ క్ష జ్ఞ".split(/\s/),
        symbols: "౦ ౧ ౨ ౩ ౪ ౫ ౬ ౭ ౮ ౯ ఓం ఽ । ॥".split(/\s/),
        other: "        ఱ".split(/\s/),
      },

      iast: {
        vowels: "a ā i ī u ū ṛ ṝ ḷ ḹ  e ai  o au".split(/\s/),
        other_marks: ["ṃ", "ḥ", "~"],
        virama: [""],
        consonants: "k kh g gh ṅ c ch j jh ñ ṭ ṭh ḍ ḍh ṇ t th d dh n " \
                    "p ph b bh m y r l v ś ṣ s h ḻ kṣ jñ".split(/\s/),
        symbols: "0 1 2 3 4 5 6 7 8 9 oṃ ' | ||".split(/\s/),
      },
      
      itrans: {
        vowels: "a A i I u U RRi RRI LLi LLI  e ai  o au".split(/\s/),
        other_marks: ["M", "H", ".N"],
        virama: [""],
        consonants: "k kh g gh ~N ch Ch j jh ~n T Th D Dh N t th d dh n " \
                    "p ph b bh m y r l v sh Sh s h L kSh j~n".split(/\s/),
        symbols: "0 1 2 3 4 5 6 7 8 9 OM .a | ||".split(/\s/),
        candra: [".c"],
        zwj: ["{}"],
        skip: ["_"],
        accent: ["\\'", "\\_"],
        combo_accent: "\\'H \\_H \\'M \\_M".split(/\s/),
        other: "q K G z .D .Dh f Y R".split(/\s/),
      },

      hk: {
        vowels: "a A i I u U R RR lR lRR  e ai  o au".split(/\s/),
        other_marks: "M H ~".split(/\s/),
        virama: [""],
        consonants: "k kh g gh G c ch j jh J T Th D Dh N t th d dh n " \
                    "p ph b bh m y r l v z S s h L kS jJ".split(/\s/),
        symbols: "0 1 2 3 4 5 6 7 8 9 OM ' | ||".split(/\s/),
      },

      slp1: {
        vowels: "a A i I u U f F x X  e E  o O".split(/\s/),
        other_marks: "M H ~".split(/\s/),
        virama: [""],
        consonants: "k K g G N c C j J Y w W q Q R t T d D n " \
                    "p P b B m y r l v S z s h L kz jY".split(/\s/),
        symbols: "0 1 2 3 4 5 6 7 8 9 oM ' | ||".split(/\s/),
      },

      velthuis: {
        vowels: "a aa i ii u uu .r .rr .li .ll  e ai  o au".split(/\s/),
        other_marks: ".m .h ".split(/\s/),
        virama: [""],
        consonants: "k kh g gh \"n c ch j jh ~n .t .th .d .dh .n t th d dh n " \
                    "p ph b bh m y r l v ~s .s s h L k.s j~n".split(/\s/),
        symbols: "0 1 2 3 4 5 6 7 8 9 o.m ' | ||".split(/\s/),
      },
      
      wx: {
        vowels: "a A i I u U q Q L   e E  o O".split(/\s/),
        other_marks: "M H z".split(/\s/),
        virama: [""],
        consonants: "k K g G f c C j J F t T d D N w W x X n " \
                    "p P b B m y r l v S R s h  kR jF".split(/\s/),
        symbols: "0 1 2 3 4 5 6 7 8 9 oM ' | ||".split(/\s/),
      },
    }

    @roman_schemes = Set.new

    @brahmic_schemes = Set.new

    @scheme_names = Set.new

    @all_alternates = {
      itrans: {
        "A" => ["aa"],
        "I" => %w[ii ee],
        "U" => %w[uu oo],
        "RRi" => ["R^i"],
        "RRI" => ["R^I"],
        "LLi" => ["L^i"],
        "LLI" => ["L^I"],
        "M" => [".m", ".n"],
        "~N" => ["N^"],
        "ch" => ["c"],
        "Ch" => %w[C chh],
        "~n" => ["JN"],
        "v" => ["w"],
        "Sh" => %w[S shh],
        "kSh" => %w[kS x],
        "j~n" => %w[GY dny],
        "OM" => ["AUM"],
        "\\_" => ["\\`"],
        "\\_H" => ["\\`H"],
        "\\'M" => ["\\'.m", "\\'.n"],
        "\\_M" => "\\_.m \\_.n \\`M \\`.m \\`.n".split(/\s/),
        ".a" => ["~"],
        "|" => ["."],
        "||" => [".."],
        "z" => ["J"],
      },
    }
  end
end