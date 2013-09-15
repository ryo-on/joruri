class Article::Attribute < ActiveRecord::Base
  include Sys::Model::Base
  include Sys::Model::Rel::Unid
  include Sys::Model::Rel::Creator
  include Sys::Model::Base::Page
  include Cms::Model::Auth::Content
  
  belongs_to :status,  :foreign_key => :state,      :class_name => 'Sys::Base::Status'
  belongs_to :content,  :foreign_key => :content_id, :class_name => 'Cms::Content'
  belongs_to :layout,  :foreign_key => :layout_id,  :class_name => "Cms::Layout"
  
  validates_presence_of :state, :name, :title
  
  def self.root_items(conditions = {})
    conditions = conditions.merge({})
    self.find(:all, :conditions => conditions, :order => :sort_no)
  end
  
  def node_label(options = {})
    title
  end
  
  def bread_crumbs(node)
    crumbs = []
    node.routes.each do |r|
      c = []
      r.each {|i| c << [i.title, i.public_uri] }
      
      uri = c.last[1] || '/'
      c << [title, "#{uri}#{name}/"]
      
      crumbs << c
    end
    Cms::Lib::BreadCrumbs.new(crumbs)
  end
end
