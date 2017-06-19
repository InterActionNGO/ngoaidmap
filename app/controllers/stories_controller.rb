class StoriesController < ApplicationController
    
    def create
        @story = Story.create(story_params)
        respond_to do |format|
           format.js 
        end
    end
    
    
    private
    def story_params
        params.require(:story).permit(:story,:image,:email,:name,:organization,:user_profession,:page)
    end
    
end
