module FieldsHelper
    def translate_field_type(value)
        if I18n.locale == :lt
            return value.sub('String', 'Tekstas').sub('Number', 'Skaičius')
            .sub('Date', 'Data')
        else
            return value
        end
    end
end
