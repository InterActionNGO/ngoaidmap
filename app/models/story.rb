class Story < ActiveRecord::Base
    include ActiveModel::ForbiddenAttributesProtection
    
    has_attached_file :image, :styles => {
        :medium => ["x500", :jpg],
        :square => ["300x300#", :jpg],
        :thumb => ["100x100#", :jpg]
        },
        :convert_options => {
            :all => "-quality 90"
        },
        :url => "/system/:class/:attachment/:id/:style.:extension"
        
    
    validates_attachment_content_type :image, :content_type => /\Aimage\/.*\z/, :message => "must be a valid image file"
    validates :image_file_name, :format => { :with => /png\z|jpe?g\z|tif\z/i, :message => "must be a valid image file" }, :allow_blank => true
    validates_attachment_size :image, :less_than => 3.megabytes, :message => "must not exceed 3MB in size"
    
    validates :story, :presence => true
    validates :story, :length => { :minimum => 5 }
    validates :email, :email => true, :allow_blank => true
    validates :user_profession, :inclusion => { :in => %w(practitioner researcher donor journalist other), :message => "%{value} is not a valid option" }, :allow_blank => true
    validates :published, :inclusion => { :in => [true, false, nil] }
    
    before_save :mark_reviewed
    
    scope :where_published, lambda {|bool| where(:published => bool) }
    scope :where_reviewed, lambda {|bool| where(:reviewed => bool) }
    
    private
    def mark_reviewed
        if self.published_changed? && !self.published.nil?
            self.reviewed = true
            self.last_reviewed_at = Time.now
        end
    end
end

