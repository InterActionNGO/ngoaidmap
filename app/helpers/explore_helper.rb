module ExploreHelper

  def explore_page_title
      return "What People Are Saying About NGO Aid Map" if action_name.eql?('stories')
      return "Discover Data Beyond The Map" if action_name.eql?('data')
  end

end
