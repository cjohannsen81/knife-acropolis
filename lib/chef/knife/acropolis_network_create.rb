require 'chef/knife'

class Chef
  class Knife
    class AcropolisNetworkCreate < Knife

      include AcropolisBase

      deps do
        require 'json'
        require 'securerandom'
      end

      banner "knife acropolis network create (options)"

      option :vlanId,
      :short => "-V ID",
      :long => "--vlanId ID",
      :description => "VLAN ID of the bridged network.",
      :proc => Proc.new { |i| Chef::Config[:knife][:vlanId] = i }

      option :prefix,
      :short => "-R ID",
      :long => "--prefix ID",
      :description => "Prefix length for the new network.",
      :proc => Proc.new { |i| Chef::Config[:knife][:prefix] = i }

      option :network,
      :short => "-N ID",
      :long => "--net-address ID",
      :description => "Network Address for the new network.",
      :proc => Proc.new { |i| Chef::Config[:knife][:network] = i }

      option :gateway,
      :short => "-G ID",
      :long => "--gateway ID",
      :description => "Gateway for the new network.",
      :proc => Proc.new { |i| Chef::Config[:knife][:gateway] = i }

      option :annotation,
      :short => "-A NAME",
      :long => "--annotation NAME",
      :description => "Annotation for the new network.",
      :proc => Proc.new { |i| Chef::Config[:knife][:annotation] = i }

      option :vswitch,
      :short => "-S NAME",
      :long => "--vswitch-name NAME",
      :description => "vSwitch name for the new network.",
      :proc => Proc.new { |i| Chef::Config[:knife][:vswitch] = i }

      option :netname,
      :short => "-N NAME",
      :long => "--network-name NAME",
      :description => "A name for the new network.",
      :proc => Proc.new { |i| Chef::Config[:knife][:netname] = i }

      def validate
        unless  Chef::Config[:knife][:vlanId] && Chef::Config[:knife][:prefix] && Chef::Config[:knife][:network] && Chef::Config[:knife][:gateway]
          ui.error('Missing VLAN ID, prefix, network or gateway. Use -v (--vlanId), -R (--prefix), -N (--net-address) and -G (--gateway) to set the mandatory values.')
          exit 1
        end
      end


      def run
        validate

        task_list = [
          ui.color('Task ID', :bold)
        ]

        #generates UUID for snapshot
        uuid = SecureRandom.uuid
        time = Time.now.to_i
        specs = '{
              "vlanId": "'"#{Chef::Config[:knife][:vlanId]}"'",
              "ipConfig": {
                "prefixLength": "'"#{Chef::Config[:knife][:prefix]}"'",
                "networkAddress": "'"#{Chef::Config[:knife][:network]}"'",
                "dhcpOptions": {
                },
                "defaultGateway": "'"#{Chef::Config[:knife][:gateway]}"'"
              },
              "annotation": "'"#{Chef::Config[:knife][:annotation]}"'",
              "vswitchName": "'"#{Chef::Config[:knife][:vswitch]}"'",
              "logicalTimestamp": "'"#{time}"'",
              "name": "'"#{Chef::Config[:knife][:netname].to_s}"'",
              "uuid": "'"#{uuid}"'"
        }'
        task = post("/networks", specs)
        uuid = JSON.parse(task)
          task_list << uuid["networkUuid"].to_s
          print ui.list(task_list, :uneven_columns_across, 1)
      end
    end
  end
end
