require 'puppetlabs_spec_helper/module_spec_helper'
require 'rspec-puppet-utils'

RSpec.configure do |c|
  c.hiera_config = 'spec/fixtures/hiera/hiera.yaml'
  c.default_facts = {
    :kernel                    => 'Linux',
    :osfamily                  => 'RedHat',
    :operatingsystem           => 'RedHat',
    :operatingsystemrelease    => '6.5',
    :operatingsystemmajrelease => '6',
  }
end
