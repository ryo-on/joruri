# encoding: utf-8
class Cms::Script::SitemapsController < Cms::Controller::Script::Publication
  def publish
    uri  = @node.public_uri
    path = @node.public_path
    publish_page(@node, :uri => uri, :path => path)
    
    render :text => (@errors.size == 0 ? "OK" : @errors.join("\n"))
  end
end
