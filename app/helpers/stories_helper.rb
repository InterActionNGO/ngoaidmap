module StoriesHelper
    
    def user_profession(story)
       if [nil,'other'].include?(story.user_profession)
           ""
       elsif story.user_profession.eql?("donor")
           "Donor / Investor"
       else
           story.user_profession
       end
    end
end
