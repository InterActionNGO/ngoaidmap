class Story < ActiveRecord::Base
    
    has_attached_file :image,
            styles: { medium: "300x300>", thumb: "100x100>" },
            default_url: "/system/:attachment/:id/:style.:extension"
    validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/
    validates_attachment_size :image, less_than: 1.megabytes
    
    validates :story, presence: true
    validates :story, length: { :minimum => 5 }
    validates :email, email: true, allow_blank: true
    
end
