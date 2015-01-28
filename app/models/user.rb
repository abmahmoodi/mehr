class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :role_ids, :as => :admin
  attr_accessible :email, :password, :password_confirmation, :remember_me
end
