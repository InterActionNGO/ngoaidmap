module PartnersHelper

    def partner_type_label
        if @partner.international == true
            'International Partner'
        elsif @partner.international == false
            'Local Partner'
        else
            'Partner'
        end
    end

end
