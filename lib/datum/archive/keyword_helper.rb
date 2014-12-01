module Datum
module KeywordHelper

  def self.handle_keywords section, tst
    unless section.keywords.nil?
      handle_clone section, tst if section.keywords.keys.include? "clone"
      handle_model section, tst if section.keywords.keys.include? "model"
    end
    section
  end

  def self.handle_clone section, tst
    instance_to_clone = tst.send(section.keywords["clone"])
    mdl = instance_to_clone.class.to_s
    if "Object" == mdl
      attrs = instance_to_clone.attributes
    else
      section.keywords["model"] = mdl
      attrs = remove_rails_defaults!(instance_to_clone.attributes)
    end
    section.attributes = attrs.merge(section.attributes)
  end

  def self.handle_model section, tst
    return unless section.keywords.keys.include? "model"
    section.keywords["klass"] = section.keywords["model"].constantize
    section.keywords["instance"] =
      section.keywords["klass"].create(section.attributes)
  end

  # delete default attributes from hash (id, created_at, updated_at)
  def self.remove_rails_defaults!(hash)
    hash.delete("id"); hash.delete("created_at"); hash.delete("updated_at")
    return hash
  end

end
end