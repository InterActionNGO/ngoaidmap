class Partnership < ActiveRecord::Base
  belongs_to :partner, class_name: 'Organization', required: true
  belongs_to :project, required: true
end
