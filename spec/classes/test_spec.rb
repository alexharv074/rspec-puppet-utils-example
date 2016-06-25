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

describe 'YAML hieradata' do

  validator = HieraData::YamlValidator.new('spec/fixtures/hieradata')
  validator.load_data :ignore_empty

  validator.validate('network::bond_static') { |v|
    it {
      expect(v).to be_a Hash
    }

    ['netmask', 'ipaddress', 'gateway'].each do |k|
      it {
        expect(v['bond0'][k]).to match /^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$/
      }
    end
  }

  validator.validate('network::bond_slave') { |v|
    it {
      expect(v).to be_a Hash
    }
    it {
      expect(v['eth0']['macaddress']).to eq 'XXXXXXXXXXXX'
    }
  }
end
