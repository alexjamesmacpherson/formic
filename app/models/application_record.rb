class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  class << self
    def id_but_nonexistent?(id)
      id && !self.exists?(id)
    end
  end
end
