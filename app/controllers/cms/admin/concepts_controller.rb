# encoding: utf-8
class Cms::Admin::ConceptsController < Cms::Controller::Admin::Base
  include Sys::Controller::Scaffold::Base
  
  def pre_dispatch
    unless @parent = Cms::Concept.find_by_id(params[:parent])
      @parent = Cms::Concept.new({
        :name     => 'コンセプト',
        :level_no => 0
      })
      @parent.id = 0
    end
    default_url_options :parent => @parent.id
  end
  
  def index
    item = Cms::Concept.new
    item.and :parent_id, @parent.id
    item.and :site_id, Core.site.id
    item.order params[:sort], :sort_no
    @items = item.find(:all)
    _index @items
  end
  
  def show
    @item = Cms::Concept.new.find(params[:id])
    return error_auth unless @item.readable?
    _show @item
  end

  def new
    @item = Cms::Concept.new({
      :parent_id  => @parent.id,
      :state      => 'public',
      :sort_no    => 0
    })
  end
  
  def create
    @item = Cms::Concept.new(params[:item])
    @item.parent_id = 0 unless @item.parent_id
    @item.site_id   = Core.site.id
    @item.level_no  = @parent.level_no + 1
    _create @item
  end
  
  def update
    @item = Cms::Concept.new.find(params[:id])
    @item.attributes = params[:item]
    @item.parent_id  = 0 unless @item.parent_id
    @item.level_no   = @parent.level_no + 1
    _update @item
  end
  
  def destroy
    @item = Cms::Concept.new.find(params[:id])
    _destroy @item do
      respond_to do |format|
        format.html { return redirect_to cms_concepts_path(@parent) }
      end
    end
  end
end
