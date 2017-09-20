module ExploreHelper

    def explore_page_title
        if action_name == 'stories'
            "What People Are Saying About NGO Aid Map" 
        elsif action_name == 'data' || controller_name.eql?('reports')
            "Discover Data Beyond The Map" 
        elsif action_name == 'use_cases'
            "Open Data: Use Cases"
        end
    end

end
