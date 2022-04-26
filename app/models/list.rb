class List < ApplicationRecord
  belongs_to :user
  belongs_to :recipe

  validates :date, presence: true

  def self.weekly_lists(current_user_id)
    List.where(user_id: current_user_id, date: Date.today..Date.today + 7)
  end
end
