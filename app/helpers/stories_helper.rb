module StoriesHelper
    
    def user_profession(story)
       if story.user_profession.nil?
           ""
       elsif story.user_profession.eql?("donor")
           "Donor / Investor"
       else
           story.user_profession
       end
    end
end
