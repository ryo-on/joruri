class Cms::Admin::Navi::ConceptsController < Cms::Controller::Admin::Base
  include Sys::Controller::Scaffold::Base
  
  def index
    skip_layout
  end
  
  def show
    if params[:id] != Core.concept(:id).to_s
      Core.set_concept(session, params[:id])
    end
    
    @item = Core.concept
    
    item = Cms::Content.new
    item.conditions_to_navi
    @contents = item.find(:all)
    
    item = Cms::Layout.new
    item.conditions_to_navi
    @layouts = item.find(:all, :order => :name)
    
    item = Cms::Piece.new
    item.conditions_to_navi
    @pieces = item.find(:all, :order => :name)
  end
end
