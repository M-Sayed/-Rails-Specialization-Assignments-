class Profile < ActiveRecord::Base
  belongs_to :user

  validates :gender,  inclusion: { in: ["male", "female"] }

  validate :full_name_is_not_null
  validate :sue_for_females_only
  

  def full_name_is_not_null 
    if self.first_name.nil? and self.last_name.nil?
      errors.add(:base, "full name should not be null")
    end
  end

  def sue_for_females_only
    if self.gender == "male" and self.first_name == "Sue"
      errors.add(:first_name, "Sue name is for females only.")
    end
  end 

  def self.get_all_profiles(min, max)
    Profile.where("birth_year BETWEEN ? AND ?", min, max).order(birth_year: :asc)
  end 
end
