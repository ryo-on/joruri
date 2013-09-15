# encoding: utf-8
require "rexml/document"

class Sys::Model::XmlRecord::Base
  @@_model_name   = nil
  @@_primary_key  = nil
  @@_attributes   = []
  @@_elements     = []
  @@_node_xpath   = ''
  @_record        = nil
  @_primary_value = nil
  
  def initialize(record, attributes = {})
    @_record = record
    self.attributes = attributes
  end
  
  def self.attr_accessor(*names)
    super(*names)
    names.each {|name| @@_attributes << name}
  end
  
  def self.elem_accessor(*names)
    attr_accessor(*names)
    names.each {|name| @@_elements << "#{name}"}
  end
  
  def self.model_name
    @@_model_name
  end
  
  def self.set_model_name(name)
    @@_model_name = name
  end
  
  def self.set_primary_key(name)
    attr_accessor(name) unless @@_attributes.index(name)
    @@_primary_key = name
  end
  
  def self.set_column_name(name)
    @@_column_name = name
  end
  
  def self.set_node_xpath(xpath)
    @@_node_xpath = xpath
  end
  
  def attributes=(_attributes)
    if _attributes.class != REXML::Element
      _attributes.each do |name, val|
        next unless self.class.method_defined?("#{name}=")
        eval("self.#{name} = val")
      end
    else
      _attributes.attributes.each do |name, val|
        next unless self.class.method_defined?("#{name}=")
        eval("self.#{name} = val")
      end
      _attributes.each do |elem|
        next unless elem.class == REXML::Element
        next unless self.class.method_defined?("#{elem.name}=")
        next unless @@_elements.index(elem.name)
        eval("self.#{elem.name} = []") unless send(elem.name)
        eval("self.#{elem.name} << elem.text")
      end
    end
    @@_elements.each do |name|
      eval("self.#{name} = []") unless send(name)
    end
  end
  
  def self.human_name
    
  end
  
  def self.human_attribute_name(name)
    label = I18n.t name, :scope => [:activerecord, :attributes, model_name]
    label =~ /^translation missing:/ ? name.to_s.humanize : label
  end
  
  def self.self_and_descendants_from_active_record
    []
  end
  
  def self.find(key, record, options = {})
    xml = eval("record.#{@@_column_name}")
    doc = REXML::Document.new(xml)
    doc.add_element 'xml' unless doc.root
    nodes = doc.root.get_elements(@@_node_xpath)
    return key == :all ? [] : nil if nodes.blank?
    
    if key == :all
      items = []
      nodes.each do |node|
        item = self.new(record, node)
        item.set_primary_value
        items << item
      end
      if options[:order] && items.size > 0
        begin
          return items.sort{|a, b| a.send(options[:order]) <=> b.send(options[:order])}
        rescue
          return items
        end
      end
      return items
    elsif key == :first
      item = self.new(record, nodes[0])
      item.set_primary_value
      return item
    end
    
    nodes.each do |node|
      if "#{node.attribute(@@_primary_key)}" == key.to_s
        item = self.new(record, node)
        item.set_primary_value
        return item
      end
    end
    return nil
  end
  
  def new_record?
    @_primary_value == nil
  end
  
  def locale(name)
    label = I18n.t name, :scope => [:activerecord, :attributes, self.class.model_name]
    label =~ /^translation missing:/ ? name.to_s.humanize : label
  end
  
  def set_primary_value
    @_primary_value = send(@@_primary_key) if @@_primary_key
  end
  
  def attributes
    attr = {}
    @@_attributes.each {|name| attr[name] = send(name) }
    attr
  end
  
  def errors
    return @_errors if @_errors
    @_errors = ActiveRecord::Errors.new(self)
  end
  
  def before_save
    true
  end
  
  def save(validation = true)
    if validation
      return false unless valid?
    end
    return false unless before_save
    eval("@_record.#{@@_column_name} = build_xml.to_s")
    return false unless @_record.save(false)
    after_save
    return true
  end
  
  def save!
    false
  end
  
  def after_save
    true
  end
  
  def before_destroy
    true
  end
  
  def destroy
    return false unless before_destroy
    eval("@_record.#{@@_column_name} = build_xml(:destroy).to_s")
    return false unless @_record.save(false)
    after_destroy
    return true
  end
  
  def after_destroy
    true
  end
  
  def to_xml_element
    node = REXML::Element.new File.basename(@@_node_xpath)
    attributes.each do |name, val|
      if @@_elements.index("#{name}")
        arr = val
        if val.class != Array
          arr = []
          val.each {|k,v| arr << v unless v.blank?}
        end
        arr.delete("")
        arr.uniq.each do |v|
          e = REXML::Element.new("#{name}");
          e.add_text(v);
          node << e
        end
      else
        node.add_attributes({"#{name}" => val})
      end
    end
    node
  end
  
  def build_xml(mode = :save)
    xml = eval("@_record.#{@@_column_name}")
    doc = REXML::Document.new(xml)
    doc.add_element('xml') unless doc.root
    
    xpath = File.dirname(@@_node_xpath)
    unless parent = doc.root.elements[xpath]
      parent = doc.root
      xpath.split('/').each do |name|
        node = parent.add_element(name)
        parent = node
      end
    end
    
    parent.each_element(File.basename(@@_node_xpath)) do |e|
      if @_primary_value
        parent.delete_element(e) if e.attribute(@@_primary_key).to_s == @_primary_value
      elsif !@@_primary_key
        parent.delete_element(e)
      end
    end
    
    if mode != :destroy
      parent << to_xml_element
    end
    
    doc
  end
  
  include ActiveRecord::Validations
  include ActiveRecord::Validations::ClassMethods
end