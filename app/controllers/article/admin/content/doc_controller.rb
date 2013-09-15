# encoding: utf-8
class Article::Admin::Content::DocController < Cms::Controller::Admin::Base
  include Sys::Controller::Scaffold::Base
  
  def pre_dispatch
    return error_auth unless @content = Cms::Content.find(params[:content])
    return error_auth unless @content.editable?
    default_url_options :content => @content
  end
  
  def show
    unless @item = Article::Content::DocConfig.find(:first, @content)
      @item = Article::Content::DocConfig.new(@content)
    end
    _show @item
  end

  def new
    exit
  end
  
  def create
    exit
  end
  
  def update
    unless @item = Article::Content::DocConfig.find(:first, @content)
      @item = Article::Content::DocConfig.new(@content)
    end
    @item.attributes = params[:item]
    _update(@item, :location => url_for(:action => :show)) 
  end
  
  def destroy
    exit
  end
end
