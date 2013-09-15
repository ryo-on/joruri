class Cms::Admin::Pages::EditController < Cms::Admin::PagesController
  def index
    item = Cms::Page.new.editable(@parent.id)

    #join = "INNER JOIN sys_creators USING(unid)"
    #item.and "sys_creators.group_id", Core.user_group.id

    item.page  params[:page], params[:limit]
    item.order params[:sort], 'updated_at DESC'
    @items = item.find(:all)
    _index @items
  end
end
