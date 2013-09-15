# encoding: utf-8
class Article::Content::DocConfig < Cms::Model::Base::ContentExtension
  set_model_name  "article/content/doc"
  set_column_name :xml_properties
  set_node_xpath  "config"
  
  attr_accessor :unit_uri
  attr_accessor :category_uri
  attr_accessor :attribute_uri
  attr_accessor :area_uri
  attr_accessor :tag_uri
  
  #validates_presence_of :unit_uri, :category_uri, :attribute_uri, :area_uri
end