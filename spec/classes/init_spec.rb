require 'spec_helper'
describe 'lemonldap' do

  context 'with defaults for all parameters' do
    it { should contain_class('lemonldap') }
  end
end
