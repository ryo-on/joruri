class Cms::Admin::Pages::PublishController < Cms::Admin::PagesController
  def index
    item = Cms::Page.new.publishable

    item.page  params[:page], params[:limit]
    item.order params[:sort], 'updated_at DESC'
    @items = item.find(:all)
    _index @items
  end
end
