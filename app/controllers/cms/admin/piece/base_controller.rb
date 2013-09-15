class Cms::Admin::Piece::BaseController < Cms::Controller::Admin::Base
  include Sys::Controller::Scaffold::Base
  
  @@_model = Cms::Piece
  
  def self.model(model)
    @@_model = model
  end
  
  def pre_dispatch
    return error_auth unless @piece = Cms::Piece.find(params[:id])
    return error_auth unless @piece.editable?
    default_url_options :piece => @piece
  end
  
  def index
    exit
  end
  
  def show
    @item = @@_model.new.find(params[:id])
    return error_auth unless @item.readable?
    _show @item
  end

  def new
    exit
  end
  
  def create
    exit
  end
  
  def update
    @item = @@_model.new.find(params[:id])
    @item.attributes = params[:item]
    
    _update @item do
      respond_to do |format|
        format.html { return redirect_to(cms_pieces_path) }
      end
    end
  end
  
  def destroy
    @item = @@_model.new.find(params[:id])
    _destroy @item do
      respond_to do |format|
        format.html { return redirect_to(cms_pieces_path) }
      end
    end
  end
end
