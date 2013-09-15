# encoding: utf-8
class Article::Script::RecentDocsController < Cms::Controller::Script::Publication
  def publish
    uri  = "#{@node.public_uri}"
    path = "#{@node.public_path}"
    publish_more(@node, :uri => uri, :path => path, :first => 2)
    
    publish_page(@node, :uri => "#{@node.public_uri}index.rss", :path => "#{@node.public_path}index.rss")
    publish_page(@node, :uri => "#{@node.public_uri}index.atom", :path => "#{@node.public_path}index.atom")
    
    render :text => "OK"
  end
end
