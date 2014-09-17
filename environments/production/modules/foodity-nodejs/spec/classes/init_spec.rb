require 'spec_helper'
describe 'nodejs' do

  context 'with defaults for all parameters' do
    it { should contain_class('nodejs') }
  end
end
