# == Schema Information
#
# Table name: cats
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  created_at :datetime
#  updated_at :datetime
#  skill      :string
#

class Cat < ActiveRecord::Base
  validates :name, :skill, presence: true
  has_many :toys
end
