# encoding: utf-8
class Faq::Content::Base < Cms::Content
  has_many :dependent_docs, :foreign_key => :content_id, :class_name => 'Faq::Doc',
    :dependent => :destroy
  has_many :dependent_categories, :foreign_key => :content_id, :class_name => 'Faq::Category',
    :dependent => :destroy
  has_many :dependent_areas, :foreign_key => :content_id, :class_name => 'Faq::Area',
    :dependent => :destroy
  has_many :dependent_attributes, :foreign_key => :content_id, :class_name => 'Faq::Attribute',
    :dependent => :destroy
end