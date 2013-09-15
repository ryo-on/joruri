# encoding: utf-8
class Article::Script::AreasController < Cms::Controller::Script::Publication
  def publish
    attrs = Article::Attribute.new.public.find(:all, :order => :sort_no)
    
    cond = {:state => 'public', :content_id => @node.content_id}
    Article::Area.root_items(cond).each do |item|
      uri  = "#{@node.public_uri}#{item.name}/"
      path = "#{@node.public_path}#{item.name}/"
      publish_page(item, :uri => uri, :path => path)
      publish_more(item, :uri => uri, :path => path, :file => 'more')
      publish_page(item, :uri => "#{uri}index.rss", :path => "#{path}index.rss")
      publish_page(item, :uri => "#{uri}index.atom", :path => "#{path}index.atom")
      
      item.public_children.each do |c|
        uri  = "#{@node.public_uri}#{c.name}/"
        path = "#{@node.public_path}#{c.name}/"
        publish_page(c, :uri => uri, :path => path)
        publish_more(c, :uri => uri, :path => path, :file => 'more')
        publish_page(c, :uri => "#{uri}index.rss", :path => "#{path}index.rss")
        publish_page(c, :uri => "#{uri}index.atom", :path => "#{path}index.atom")
        
        attrs.each do |attr|
          uri  = "#{@node.public_uri}#{c.name}/#{attr.name}/"
          path = "#{@node.public_path}#{c.name}/#{attr.name}/"
          publish_more(c, :uri => uri, :path => path)
        end
      end
    end
    
    render :text => (@errors.size == 0 ? "OK" : @errors.join("\n"))
  end
end
