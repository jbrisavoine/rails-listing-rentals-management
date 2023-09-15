class Booking < ApplicationRecord
  belongs_to :listing
  has_many :missions, dependent: :destroy
end
