# encoding: utf-8
module Cms::Model::Base::Node
  def self.included(mod)
    mod.belongs_to :status, :foreign_key => :state, :class_name => 'Sys::Base::Status'
  end
  
  def content_name
    return content.name if content
    Cms::Lib::Modules.module_name(:cms)
  end
  
  def model_name(option = nil)
    name = Cms::Lib::Modules.model_name(:node, model)
    return name.to_s.gsub(/^.*?\//, '') if option == :short
    name
  end
  
  def model_type
    return nil unless mod = Cms::Lib::Modules.find(:node, model)
    mod.type
  end
  
  def admin_uri
    controller = model.underscore.pluralize.gsub(/^(.*?\/)/, "\\1#{parent_id}/node_")
    return "#{Core.uri}_admin/#{controller}/#{id}"
  end
  
  def edit_admin_uri
    "#{admin_uri}/edit"
  end
  
  def routes
    routes = [self]
    parent_id = route_id
    loop = 0
    while current = self.class.find_by_id(parent_id)
      routes.unshift(current)
      parent_id = current.route_id
      break if parent_id == 0
      break if (loop += 1) > 10
    end
    [routes]
  end
  
  def bread_crumbs(node = nil)
    crumbs = []
    node ||= self
    node.routes.each do |r|
      c = []
      r.each {|i| c << [i.title, i.public_uri] }
      crumbs << c
    end
    Cms::Lib::BreadCrumbs.new(crumbs)
  end
end