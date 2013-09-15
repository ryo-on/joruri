class Sys::UsersRole < ActiveRecord::Base
  include Sys::Model::Base
  include Sys::Model::Base::Config
  
  set_primary_key :rid
  
  belongs_to   :role, :foreign_key => :role_id, :class_name => 'Sys::Role'
  belongs_to   :user, :foreign_key => :user_id, :class_name => 'Sys::User'
end
