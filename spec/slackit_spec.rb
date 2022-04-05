# frozen_string_literal: true

require 'slackit'

RSpec.describe Slackit do
    it 'has a version number' do
        expect(Slackit::VERSION).not_to be nil
    end
end
