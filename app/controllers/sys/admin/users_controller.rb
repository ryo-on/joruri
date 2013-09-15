# encoding: utf-8
class Sys::Admin::UsersController < Cms::Controller::Admin::Base
  include Sys::Controller::Scaffold::Base
  
  def pre_dispatch
    return redirect_to(request.env['PATH_INFO']) if params[:reset]
    
    id      = params[:parent] == '0' ? 1 : params[:parent]
    @parent = Sys::Group.new.find(id)
  end
  
  def index
#    item = Sys::User.new.readable
#    item.search params
#    item.page  params[:page], params[:limit]
#    item.order params[:sort], :id
#    @items = item.find(:all)
#    _index @items
  end
  
  def show
    @item = Sys::User.new.find(params[:id])
    return error_auth unless @item.readable?
    
    _show @item
  end

  def new
    @item = Sys::User.new({
      :state      => 'enabled',
      :ldap       => '0',
      :auth_no    => 2,
      :group_id   => @parent.id
    })
  end
  
  def create
    @item = Sys::User.new(params[:item])
    _create(@item, :location => sys_groups_path(@parent)) do
      save_users_group(@item, params[:item][:group_id])
    end
  end
  
  def update
    @item = Sys::User.new.find(params[:id])
    @item.attributes = params[:item]
    _update(@item, :location => sys_groups_path(@parent)) do
      save_users_group(@item, params[:item][:group_id])
    end
  end
  
  def destroy
    @item = Sys::User.new.find(params[:id])
    _destroy(@item, :location => sys_groups_path(@parent))
  end
  
  def save_users_group(item, group_id)
    return true unless group_id
    unless ug = item.group_rels[0]
      ug = Sys::UsersGroup.new({:user_id => item.id})
    end
    if ug.group_id != group_id
      ug.group_id = group_id
      ug.save
    end
    return true
  end
end
