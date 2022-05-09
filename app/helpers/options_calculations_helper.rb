module OptionsCalculationsHelper
    def translate_words(word)
        if I18n.locale == :lt
            case word
            when 'Grant Date'
                return 'Išdavimo data'
            when 'Vesting Start Date'
                return 'Kaupimosi pradžia'
            when 'Cliff'
                return 'Cliff'
            when 'Tranches'
                return 'Segmentai'
            when 'Grant Type'
                return 'Paketo tipas'
            when 'Share Number'
                return 'Opcionų skaičius'
            when 'Vesting End Date'
                return 'Kaupimosi pabaiga'
            end
        else
            return word
        end
    end
end
