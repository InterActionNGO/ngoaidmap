class ImplementerPartnership < ActiveRecord::Base
  belongs_to :implementer, class_name: 'Organization', required: true
  belongs_to :project, required: true
end
