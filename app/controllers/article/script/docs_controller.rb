# encoding: utf-8
class Article::Script::DocsController < Cms::Controller::Script::Publication
  def publish
    if @node
      uri  = "#{@node.public_uri}"
      path = "#{@node.public_path}"
      publish_more(@node, :uri => uri, :path => path, :first => 2)
      render :text => "OK"
    end
    
    begin
      item = params[:item]
      puts "-- 公開 #{item.title}"
      if item.state == 'recognized'
        item.publish(render_public_as_string(item.public_uri, :site => item.content.site))
      end
    rescue => e
      return render(:text => "Error #{e}")
    end
    render :text => "OK"
  end
  
  def close
    begin
      item = params[:item]
      puts "-- 非公開 #{item.title}"
      if item.state == 'public'
        item.close
      end
    rescue => e
      return render(:text => "Error #{e}")
    end
    render :text => "OK"
  end
end
