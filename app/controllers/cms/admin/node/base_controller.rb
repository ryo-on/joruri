class Cms::Admin::Node::BaseController < Cms::Controller::Admin::Base
  include Sys::Controller::Scaffold::Base
  
  def pre_dispatch
    id      = params[:parent] == '0' ? Core.site.node_id : params[:parent]
    @parent = Cms::Node.new.find(id)
  end
  
  def index
    exit
  end
  
  def show
    @item = Cms::Node.new.find(params[:id])
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
    @item = Cms::Node.new.find(params[:id])
    @item.attributes = params[:item]
    
    _update @item do
      respond_to do |format|
        format.html { return redirect_to(cms_nodes_path) }
      end
    end
  end
  
  def destroy
    @item = Cms::Node.new.find(params[:id])
    _destroy @item do
      respond_to do |format|
        format.html { return redirect_to(cms_nodes_path) }
      end
    end
  end
end
