class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  has_many :assignments

  def type
    if self.user_type.blank?
      return :student
    elsif self.user_type.downcase == "ta"
      return :ta
    end
  end

  def display_name
    name_string = ""
    name_string += self.first_name + " "
    name_string += self.last_name
    name_string
  end
end
