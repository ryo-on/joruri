module Cms::Model::Navi
  def conditions_to_navi
    if Core.concept
      self.and :concept_id, Core.concept.id
    else
      self.and :concept_id, 'IS', nil
    end
    
    if Core.site
      self.and :site_id, Core.site.id
    else
      self.and :site_id, 'IS', nil
    end
  end
end