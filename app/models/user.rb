class User < ApplicationRecord
  rolify
  #after_create :assign_role
  # after_action :assign_employee_id
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
   :validatable, :timeoutable, :omniauthable, omniauth_providers: [:google_oauth2]

  def self.assign_role(user)
    relevant_role = Participant.where(email: user.email).first
    puts '---------------------------------------------'
    puts relevant_role.role.name
    puts '---------------------------------------------ENDING'
    user.remove_role :admin if relevant_role.role.name == "user"
    user.remove_role :user if !relevant_role.present?
    if relevant_role.present?
      user.add_role(relevant_role.role.name)
      if relevant_role.role.name == 'admin'
        user.add_role(:user)
      end
    end
  end

  def self.assign_employee_id(user)
    relevant_role = Participant.where(email: user.email).first
    if relevant_role.present?
      user.update!(employee_id: relevant_role.employee_id)
    end
  end
  # :nocov:
  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.where(email: data['email']).first
    assign_role(user) if user.present?
    assign_employee_id(user) if user.present?
    # Uncomment the section below if you want users to be created if they don't exist
    unless user
        user = User.create!(name: data['name'],
           email: data['email'],
           password: Devise.friendly_token,
           photo_url: data['image']
        )
        assign_role(user)
        assign_employee_id(user)
        return user
    end
    return user
  end
  # :nocov:
end
