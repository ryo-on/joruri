module Cms::Model::Auth::Concept
  def editable
    self.and("1", "=", "0") unless Core.user.has_priv?(:update, :item => Core.concept)
    return self
  end

  def editable?
    return true if Core.user.has_auth?(:manager)
    return Core.user.has_priv?(:update, :item => Core.concept)
  end

  def deletable?
    return true if Core.user.has_auth?(:manager)
    return Core.user.has_priv?(:delete, :item => Core.concept)
  end
end