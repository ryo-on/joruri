class Cms::Model::Base::PieceExtension < Sys::Model::XmlRecord::Base
  set_column_name :xml_properties
  
  def piece
    @_record
  end
  
  def creatable?
    @_record.editable?
  end
  
  def editable?
    @_record.editable?
  end
  
  def deletable?
    @_record.editable?
  end
end