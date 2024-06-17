class Current < ActiveSupport::CurrentAttributes
  attribute :user, :company

  # Add any custom methods or attributes that need to be globally accessible
  # within the request lifecycle
end