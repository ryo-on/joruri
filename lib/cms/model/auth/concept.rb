module Cms::Model::Auth::Concept
  def readable
    self.and("1", "=", "0") unless Core.user.has_priv?(:read, :item => Core.concept)
    return self
  end
  
  def editable
    self.and("1", "=", "0") unless Core.user.has_priv?(:update, :item => Core.concept)
    return self
  end

  def creatable?
    return true if Core.user.has_auth?(:manager)
    return Core.user.has_priv?(:create, :item => Core.concept)
  end
  
  def readable?
    return true if Core.user.has_auth?(:manager)
    return Core.user.has_priv?(:read, :item => concept)
  end
  
#  def editable?
#    return true if Core.user.has_auth?(:manager)
#    return Core.user.has_priv?(:update, :item => concept)
#  end

#  def deletable?
#    return true if Core.user.has_auth?(:manager)
#    return Core.user.has_priv?(:delete, :item => concept)
#  end
end