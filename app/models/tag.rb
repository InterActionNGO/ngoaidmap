# == Schema Information
#
# Table name: tags
#
#  id    :integer          not null, primary key
#  name  :string(255)
#  count :integer          default(0)
#

class Tag < ActiveRecord::Base

  has_and_belongs_to_many :projects,
          :before_add => :increment_tag_counter,
          :before_remove => :decrement_tag_counter
  has_and_belongs_to_many :sites

  validates_uniqueness_of :name
  
  def self.update_all_counts
    self.find_each do |tag|
         puts "Updating count for tag: #{tag.name}"
         tag.count = tag.projects.uniq.size
         tag.save!
      end
  end

  def increment_tag_counter (project)
    self.class.increment_counter(:count, id)
  end
  
  def decrement_tag_counter (project)
    self.class.decrement_counter(:count, id)
  end

end
