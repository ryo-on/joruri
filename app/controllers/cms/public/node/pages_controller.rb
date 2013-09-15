# encoding: utf-8
class Cms::Public::Node::PagesController < Cms::Controller::Public::Base
  def index
    @item = Core.current_node
    
    Page.current_item = @item
    Page.title        = @item.title
  end
end
