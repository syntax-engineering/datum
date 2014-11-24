module Datum
module Utilities

  # delete default attributes from hash (id, created_at, updated_at)
  #
  def self.remove_rails_defaults!(hash)
    hash.delete("id"); hash.delete("created_at"); hash.delete("updated_at")
    return hash
  end

end
end