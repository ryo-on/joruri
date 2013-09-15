# encoding: utf-8
require 'digest/sha1'
class Sys::User < ActiveRecord::Base
  include Sys::Model::Base
  include Sys::Model::Base::Config

  belongs_to :status,     :foreign_key => :state,    :class_name => 'Sys::Base::Status'
  has_many   :group_rels, :foreign_key => :user_id,  :class_name => 'Sys::UsersGroup'  , :primary_key => :id
  has_and_belongs_to_many :groups, :class_name => 'Sys::Group', :join_table => 'sys_users_groups'
  
  attr_accessor :group, :group_id
  
  validates_presence_of :state, :ldap, :name

  def readable
    self
  end
  
  def creatable?
    Core.user.has_priv?(:manager)
  end
  
  def readable?
    Core.user.has_priv?(:manager)
  end
  
  def editable?
    Core.user.has_priv?(:manager)
  end
  
  def deletable?
    Core.user.has_priv?(:manager)
  end
  
  def authes
    #[['なし',0], ['投稿者',1], ['作成者',2], ['編集者',3], ['設計者',4], ['管理者',5]]
    [['作成者',2], ['設計者',4], ['管理者',5]]
  end
  
  def auth_name
    authes.each {|a| return a[0] if a[1] == auth_no }
    return nil
  end
  
  def ldap_states
    [['同期',1],['非同期',0]]
  end
  
  def ldap_label
    ldap_states.each {|a| return a[0] if a[1] == ldap }
    return nil
  end
  
  def name_with_id
    "#{name}（#{id}）"
  end

  def label(name)
    case name; when nil; end
  end
  
  def group
    Sys::Group.find_by_id(group_id)
  end
  
  def group_id
    return @group_id if @group_id
    groups.size == 0 ? nil : groups[0].id
  end
  
  def has_auth?(name)
    auth = {
      :none     => 0, # なし  操作不可
      :reader   => 1, # 読者  閲覧のみ
      :creator  => 2, #作成者 記事作成者
      :editor   => 3, #編集者 データ作成者
      :designer => 4, #設計者 デザイン作成者
      :manager  => 5, #管理者 設定作成者
    }
    raise "Unknown authority name: #{name}" unless auth.has_key?(name)
    return auth[name] <= auth_no
  end

  def has_priv?(action, options = {})
    unless options[:auth_off]
      return true if has_auth?(:manager)
    end
    return nil unless options[:item]

    item = options[:item]
    if item.kind_of?(ActiveRecord::Base)
      item = item.unid
    end
    
    cond = {:action => action, :item_unid => item}
    roles = Sys::ObjectPrivilege.find(:all, :conditions => cond)
    return false if roles.size == 0
    
    cond = Condition.new do |c|
      c.and :user_id, id
      c.and :role_id, 'ON', roles.collect{|i| i.role_id}
    end
    Sys::UsersRole.find(:first, :conditions => cond.where)
  end

  def delete_group_relations
    Sys::UsersGroup.delete_all(:user_id => id)
    return true
  end

  def search(params)
    params.each do |n, v|
      next if v.to_s == ''

      case n
      when 's_id'
        self.and :id, v
      when 's_name'
        self.and :name, 'LIKE', "%#{v.gsub(/([%_])/, '\\\\\1')}%"
      when 's_email'
        self.and :email, 'LIKE', "%#{v.gsub(/([%_])/, '\\\\\1')}%"
      end
    end if params.size != 0

    return self
  end

  ## -----------------------------------
  ## Authenticates

  ## Authenticates a user by their account name and unencrypted password.  Returns the user or nil.
  def self.authenticate(in_account, in_password, encrypted = false)
    in_password = Util::String::Crypt.decrypt(in_password) if encrypted
    
    return false unless user = self.new.enabled.find(:first, :conditions => {:account => in_account})
    
    ## LDAP Auth
    if user.ldap == 1
      return false unless ou1 = user.groups[0]
      return false unless ou2 = ou1.parent
      dn = "uid=#{user.account},ou=#{ou1.ou_name},ou=#{ou2.ou_name},#{Core.ldap.base}"
      return false unless Core.ldap.bind(dn, in_password)
    end
    
    ## DB Auth
    return false if in_password != user.password || user.password.to_s == ''
    return user
  end

  def encrypt_password
    return if password.blank?
    Util::String::Crypt.encrypt(password)
  end
  
  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at
  end

  def remember_me
    self.remember_token_expires_at = 2.weeks.from_now.utc
    self.remember_token            = encrypt("#{email}--#{remember_token_expires_at}")
    save(false)
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(false)
  end

protected
  def password_required?
    password.blank?
  end
end
