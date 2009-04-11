class Sheet < ActiveRecord::Base
  belongs_to :game
  has_many :entries

end