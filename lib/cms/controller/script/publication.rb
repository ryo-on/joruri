class Cms::Controller::Script::Publication < ApplicationController
  include Cms::Controller::Layout
  before_filter :initialize_publication
  
  def initialize_publication
    if @node = params[:node]
      @site   = @node.site
    end
    @errors = []
  end
  
  def publish_page(item, params = {})
    site = params[:site] || @site
    res = item.publish_page(render_public_as_string(params[:uri], :site => site), :path => params[:path])
    if res == true && params[:path] =~ /(\/|\.html)$/
      uri  = (params[:uri] =~ /\.html$/ ? "#{params[:uri]}.r" : "#{params[:uri]}index.html.r")
      path = (params[:path] =~ /\.html$/ ? "#{params[:path]}.r" : "#{params[:path]}index.html.r")
      item.publish_page(render_public_as_string(uri, :site => site), :path => path)
    end
    return res
  rescue
    return false
  end
  
  def publish_more(item, params = {})
    file  = params[:file] || 'index'
    first = params[:first] || 1
    first.upto(30) do |p|
      page = (p == 1 ? "" : ".p#{p}") 
      uri  = "#{params[:uri]}#{file}#{page}.html"
      path = "#{params[:path]}#{file}#{page}.html"
      break unless publish_page(item, :uri => uri, :site => params[:site], :path => path)
    end
  end
end
