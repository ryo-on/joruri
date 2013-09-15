# encoding: utf-8
class Article::Public::Node::AttributesController < Cms::Controller::Public::Base
  include Article::Controller::Feed

  def pre_dispatch
    return http_error(404) unless @content = Core.current_node.content
    
    @limit = 10
    
    if params[:name]
      item = Article::Attribute.new.public
      item.and :content_id, @content.id
      item.and :name, params[:name]
      return http_error(404) unless @item = item.find(:first)
      Page.current_item = @item
      Page.title        = @item.title
    end
  end
  
  def index
    item = Article::Attribute.new.public
    item.and :content_id, @content.id
    @items = item.find(:all, :order => :sort_no)
  end
  
  def show
    return http_error(404) unless params[:file] =~ /^(index|more)$/
    @more  = params[:file] == 'more'
    @limit = 50 if @more
    
    doc = Article::Doc.new.public
    doc.agent_filter(request.mobile)
    doc.and :content_id, @content.id
    doc.visible_in_recent
    doc.attribute_is @item
    doc.page params[:page], @limit
    @docs = doc.find(:all, :order => 'published_at DESC')
    return true if render_feed(@docs)
    
    @items = Article::Unit.find_departments(:web_state => 'public')

    @item_docs = Proc.new do |dep|
      doc = Article::Doc.new.public
      doc.agent_filter(request.mobile)
      doc.and :content_id, @content.id
      doc.visible_in_list
      doc.attribute_is @item
      doc.unit_is dep
      doc.page 1, @limit
      @docs = doc.find(:all, :order => 'published_at DESC')
    end
  end
  
  def show_attr
    attr = Article::Unit.new.public
    attr.and :name_en, params[:attr]
    return http_error(404) unless @attr = attr.find(:first, :order => :sort_no)
    
    doc = Article::Doc.new.public
    doc.agent_filter(request.mobile)
    doc.and :content_id, @content.id
    doc.visible_in_list
    doc.attribute_is @item
    doc.unit_is @attr
    doc.page params[:page], @limit
    @docs = doc.find(:all, :order => 'published_at DESC')
  end
end
