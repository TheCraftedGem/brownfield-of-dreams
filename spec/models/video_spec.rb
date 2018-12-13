require 'rails_helper'

RSpec.describe Video, type: :model do
  it { is_expected.to validate_numericality_of :position }
end
