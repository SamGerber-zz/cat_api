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
