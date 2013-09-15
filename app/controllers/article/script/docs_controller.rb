# encoding: utf-8
class Article::Script::DocsController < ApplicationController
  include Cms::Controller::Layout
  
  def publish
    begin
      item = params[:item]
      puts "-- 公開 #{item.title}"
      if item.state == 'recognized'
        item.publish(render_public_as_string(item.public_uri, item.content.site))
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
