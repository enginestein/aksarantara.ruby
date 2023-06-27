#[macro_use]
extern crate lazy_static;
extern crate regex;
extern crate ruby_sys;

#[macro_use]
mod rb;
pub mod detect; 

#[cfg(test)]
mod tests {
    use detect::detect_scheme;

    #[test]
    fn detect_devanagari() {
        assert_eq!(detect_scheme("नानाशास्त्रसुभाषितामृतरसैः श्रोत्रोत्सवं कुर्वतां येषां यान्ति दिनानि पण्डितजनव्यायामखिन्नात्मनाम् तेषां जन्म च जीवितं च सुकृतं तैर् एव भूर् भूषिता शेषैह् किं पशुवद् विवेकरहितैर् भूभारभूतैर् नरः"), 1);
    }

    #[test]
    fn detect_malayalam() {
        assert_eq!(detect_scheme("നാനാശാസ്ത്രസുഭാഷിതാമൃതരസൈഃ ശ്രോത്രോത്സവം കുര്വതാം യേഷാം യാന്തി ദിനാനി പണ്ഡിതജനവ്യായാമഖിന്നാത്മനാമ് തേഷാം ജന്മ ച ജീവിതം ച സുകൃതം തൈര് ഏവ ഭൂര് ഭൂഷിതാ ശേഷൈഹ് കിം പശുവദ് വിവേകരഹിതൈര് ഭൂഭാരഭൂതൈര് നരഃ"), 9);
    }

    #[test]
    fn detect_iast() {
        assert_eq!(detect_scheme("nānāśāstrasubhāṣitāmṛtarasaiḥ śrotrotsavaṃ kurvatāṃ yeṣāṃ yānti dināni paṇḍitajanavyāyāmakhinnātmanām teṣāṃ janma ca jīvitaṃ ca sukṛtaṃ tair eva bhūr bhūṣitā śeṣaih kiṃ paśuvad vivekarahitair bhūbhārabhūtair naraḥ"), 10);
    }

    #[test]
    fn detect_slp1() {
        assert_eq!(detect_scheme("nAnASAstrasuBAzitAmftarasEH SrotrotsavaM kurvatAM yezAM yAnti dinAni paRqitajanavyAyAmaKinnAtmanAm tezAM janma ca jIvitaM ca sukftaM tEr eva BUr BUzitA SezEh kiM paSuvad vivekarahitEr BUBAraBUtEr naraH"), 13);
    }

    #[test]
    fn detect_hk() {
        assert_eq!(detect_scheme("nAnAzAstrasubhASitAmRtarasaiH zrotrotsavaM kurvatAM yeSAM yAnti dinAni paNDitajanavyAyAmakhinnAtmanAm teSAM janma ca jIvitaM ca sukRtaM tair eva bhUr bhUSitA zeSaih kiM pazuvad vivekarahitair bhUbhArabhUtair naraH"), 15);
    }
}
