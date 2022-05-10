module GrantRulesHelper
    def translate_trigger(value)
        if I18n.locale == :lt
            if 'field value has changed'.in? value
                return 'kai duomenys pasikeitė - ' + value.split(' - ')[-1]
            else
                case value
                when 'when employee has historical data'
                    return 'kai darbuotojas turi istorinių duomenų'
                when 'when employee has no historical data'
                    return 'kai darbuotojas neturi istorinių duomenų'
                when 'always'
                    return 'visada'
                when 'never'
                    return 'niekada'
                end
            end
        else
            return value
        end
    end
end
