class ApiKey < ApplicationRecord
  belongs_to :user

  enum source: [:github]
end
