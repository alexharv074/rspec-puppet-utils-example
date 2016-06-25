require 'spec_helper'

describe 'test' do
  before(:each) {
    MockFunction.new('is_mac_address') { |f|
      f.stubs(:call).with(['XXXXXXXXXXXX']).returns(true)
    }
  }

  it {
    is_expected.to contain_network__bond__static('bond0').with(
      'ensure'       => 'up',
      'ipaddress'    => '10.0.0.10',
      'netmask'      => '255.255.255.0',
      'gateway'      => '10.0.0.254',
      'bonding_opts' => 'mode=active-backup miimon=100',
    )
  }

  it {
    is_expected.to contain_network__bond__slave('eth0').with(
      'macaddress'   => 'XXXXXXXXXXXX',
      'ethtool_opts' => 'autoneg off speed 1000 duplex full',
      'master'       => 'bond0',
    )
  }
end
