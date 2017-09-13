class HumanitarianScope < ActiveRecord::Base
  belongs_to :project
  belongs_to :humanitarian_scope_type
  belongs_to :humanitarian_scope_vocabulary

  validates :project,
            :humanitarian_scope_type,
            :humanitarian_scope_vocabulary,
            :code,
            presence: true

  validates :vocabulary_uri, presence: {
    if: -> (scope) do
      scope.humanitarian_scope_vocabulary &&
      scope.humanitarian_scope_vocabulary.url.blank?
    end
  }
end
