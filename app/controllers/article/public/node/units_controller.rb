# encoding: utf-8
class Article::Public::Node::UnitsController < Cms::Controller::Public::Base
  include Article::Controller::Feed

  def pre_dispatch
    return http_error(404) unless @content = Core.current_node.content
    
    @limit = 10
    
    if params[:name]
      item = Article::Unit.new.public
      item.and :name_en, params[:name]
      return http_error(404) unless @item = item.find(:first)
      Page.current_item = @item
      Page.title        = @item.title
    end
  end
  
  def index
    @items = Article::Unit.root_item.public_children
  end

  def show
    return http_error(404) unless params[:file] =~ /^(index|more)$/
    @more  = params[:file] == 'more'
    @limit = 50 if @more
    
    doc = Article::Doc.new.public
    doc.and :content_id, @content.id
    request.mobile? ? doc.visible_in_list : doc.visible_in_recent
    doc.unit_is @item
    doc.page params[:page], @limit
    @docs = doc.find(:all, :order => 'published_at DESC')
    return true if render_feed(@docs)
    
    if @item.level_no == 2
      show_department
      return render :action => :show_department
    elsif @item.level_no > 2
      show_section
      return render :action => :show_section
    end
    return http_error(404)
  end

  def show_department
    attr = Article::Attribute.new.public
    @items = attr.find(:all, :order => :sort_no)

    @item_docs = Proc.new do |attr|
      doc = Article::Doc.new.public
      doc.and :content_id, @content.id
      doc.visible_in_list
      doc.unit_is @item
      doc.attribute_is attr
      doc.page 1, @limit
      @docs = doc.find(:all, :order => 'published_at DESC')
    end
  end

  def show_section
    attr = Article::Attribute.new.public
    @items = attr.find(:all, :order => :sort_no)

    @item_docs = Proc.new do |attr|
      doc = Article::Doc.new.public
      doc.and :content_id, @content.id
      doc.visible_in_list
      doc.unit_is @item
      doc.attribute_is attr
      doc.page 1, @limit
      @docs = doc.find(:all, :order => 'published_at DESC')
    end
  end
  
  def show_attr
    attr = Article::Attribute.new.public
    attr.and :name, params[:attr]
    return http_error(404) unless @attr = attr.find(:first, :order => :sort_no)
    
    doc = Article::Doc.new.public
    doc.and :content_id, @content.id
    doc.visible_in_list
    doc.unit_is @item
    doc.attribute_is @attr
    doc.page params[:page], @limit
    @docs = doc.find(:all, :order => 'published_at DESC')
  end
end
