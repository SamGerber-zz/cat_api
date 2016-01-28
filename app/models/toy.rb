# == Schema Information
#
# Table name: toys
#
#  id         :integer          not null, primary key
#  cat_id     :integer          not null
#  name       :string           not null
#  ttype      :string           not null
#  created_at :datetime
#  updated_at :datetime
#

class Toy < ActiveRecord::Base
  TTYPES = [
    "string",
    "yarnball",
    "mouse"
  ]
  validates :cat_id, :name, :ttype, presence: true
  validates :ttype, inclusion: TTYPES

  belongs_to :cat
end
