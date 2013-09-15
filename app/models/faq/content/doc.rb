# encoding: utf-8
class Faq::Content::Doc < Cms::Content
  def doc_node
    return @doc_node if @doc_node
    item = Cms::Node.new.public
    item.and :content_id, id
    item.and :model, 'Faq::Doc'
    @doc_node = item.find(:first, :order => :id)
  end
  
  def category_node
    return @category_node if @category_node
    item = Cms::Node.new.public
    item.and :content_id, id
    item.and :model, 'Faq::Category'
    @category_node = item.find(:first, :order => :id)
  end
  
  def recent_node
    return @recent_node if @recent_node
    item = Cms::Node.new.public
    item.and :content_id, id
    item.and :model, 'Faq::RecentDoc'
    @recent_node = item.find(:first, :order => :id)
  end
  
  def tag_node
    return @tag_node if @tag_node
    item = Cms::Node.new.public
    item.and :content_id, id
    item.and :model, 'Faq::TagDoc'
    @tag_node = item.find(:first, :order => :id)
  end
end