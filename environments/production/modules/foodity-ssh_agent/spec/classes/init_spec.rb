require 'spec_helper'
describe 'ssh_agent' do

  context 'with defaults for all parameters' do
    it { should contain_class('ssh_agent') }
  end
end
