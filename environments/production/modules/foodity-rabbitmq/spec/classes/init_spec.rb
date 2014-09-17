require 'spec_helper'
describe 'rabbitmq' do

  context 'with defaults for all parameters' do
    it { should contain_class('rabbitmq') }
  end
end
