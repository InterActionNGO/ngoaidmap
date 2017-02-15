module Api
    module V1
        class TagsController < ApiController
        
            def index
                @tags = Tag.all
                render json: @tags,
                    meta: { total_records: Tag.count,
                        returned_records: @tags.count,
                        current_offset: tags_params[:offset].to_i
                        }
            end
      
            def show
                @tag = Tag.find(params[:id])
                render json: @tag, include: [:projects]
            
            end
            
            def tags_params
                params.permit(:offset, :limit)
            end
        end
    end
end