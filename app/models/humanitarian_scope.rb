class HumanitarianScope < ActiveRecord::Base
  belongs_to :project
  belongs_to :humanitarian_scope_type
  belongs_to :humanitarian_scope_vocabulary

  validates :project,
            :humanitarian_scope_type,
            :humanitarian_scope_vocabulary,
            presence: true
end
