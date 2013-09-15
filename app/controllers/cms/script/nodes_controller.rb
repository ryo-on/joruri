class Cms::Script::NodesController < Cms::Controller::Script::Publication
  def publish
    @ids  = {}
    
    Cms::Node.new.public.find(:all, :conditions => {:parent_id => 0}, :order => "name, id").each do |node|
      publish_node(node)
    end
    
    render :text => "OK"
  end
  
  def publish_node(node)
    return error_log(e) if @ids.key?(node.id)
    @ids[node.id] = 1
    
    Cms::Node.new.find(:all, :conditions => {:parent_id => node.id}, :order => "directory, name, id").each do |item|
      if !item.public?
        FileUtils.rm_rf(item.public_path) if File.exist?(item.public_path)
        next
      end
      
      ## page
      if item.model == 'Cms::Page'
        begin
          publish_page(item, :uri => item.public_uri, :site => item.site, :path => item.public_path)
        rescue => e
          error_log(e)
        end
        next
      end
      
      ## modules' page
      if item.model != 'Cms::Directory'
        begin
          publish_page(item, :uri => item.public_uri, :site => item.site, :path => item.public_path)
          model = item.model.underscore.pluralize
          res   = render_component_as_string :controller => model.gsub(/^(.*?)\//, '\1/script/'),
            :action => "publish", :params => {:node => item}
        rescue => e
          error_log(e)
        end
      end
      
      publish_node(item)
    end
  end
end
