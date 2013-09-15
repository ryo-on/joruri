module Cms::Model::Navi
  def conditions_to_navi
    if concept = Core.concept
      self.and :concept_id, concept.id
    else
      self.and :concept_id, 'IS', nil
    end
  end
end