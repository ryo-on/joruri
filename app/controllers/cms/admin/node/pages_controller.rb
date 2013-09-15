class Cms::Admin::Node::PagesController < Cms::Admin::Node::BaseController
  def edit
    @item = Cms::Node.new.find(params[:id])
    return error_auth unless @item.readable?
    @item.name ||= 'index.html'
    _show @item
  end
end
