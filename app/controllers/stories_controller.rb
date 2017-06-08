class StoriesController < ApplicationController
    
    def new
    end
    
    def create
        
        @story = Story.create(story_params)
        
    end
    
    def edit
    end
    
    def update
    end
    
    def destroy
    end
    
    def show
    end
    
    private
    def story_params
        params.require(:story).permit(:story,:image,:email,:name,:organization)
    end
    
end
