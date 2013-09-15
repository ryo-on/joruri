# encoding: utf-8
module Cms::Model::Base::Page
  def states
    [['公開','public'],['非公開','closed']]
  end

  def public
    self.and "#{self.class.table_name}.state", 'public'
#    self.and "#{self.class.table_name}.published_at", 'IS NOT', nil
    self
  end
  
  def public?
    return state == 'public' && published_at
  end

  def public_or_preview
    return self if Core.mode == 'preview'
    public
  end
  
  def publish_page(content, options = {})
    if content.nil?
      FileUtils.rm_f (options[:path] || public_path)
      return false
    end
    
    path = (options[:path] || public_path).gsub(/\/$/, "/index.html")
    if File::exist?(path)
      if content.bytesize == File::stat(path).size
        return nil if content == File.new(path).read
      end
    end
    Util::File.put(path, :data => content, :mkdir => true)
    return true
  end
  
  def close_page
    #
  end
end