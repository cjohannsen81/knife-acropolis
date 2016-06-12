require 'chef/knife'

class Chef
  class Knife
    class AcropolisVmCreate < Knife

      include AcropolisBase

      deps do
        require 'json'
        require 'securerandom'
      end

      banner "knife acropolis vm create (options)"

      option :mem,
      :short => "-M MB",
      :long => "--mem MB",
      :description => "Memory in MegaBytes",
      :proc => Proc.new { |i| Chef::Config[:knife][:mem] = i }

      option :cpu,
      :short => "-C CORES",
      :long => "--cpu CORES",
      :description => "CPU cores",
      :proc => Proc.new { |i| Chef::Config[:knife][:cpu] = i }

      option :chef_node_name,
      :short => "-N NAME",
      :long => "--node-name NAME",
      :description => "The Chef node name for your new node",
      :proc => Proc.new { |key| Chef::Config[:knife][:chef_node_name] = key }

      def validate
        unless  Chef::Config[:knife][:mem] && Chef::Config[:knife][:cpu] && Chef::Config[:knife][:chef_node_name]
          ui.error('Missing mem, cpu, name or gateway. Use -M (--mem), -C (--cpu), -N (--node-name) and -G (--gateway) to set the mandatory values.')
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
          "name": "'"#{Chef::Config[:knife][:chef_node_name].to_s}"'",
          "memoryMb": "'"#{Chef::Config[:knife][:mem].to_s}"'",
          "numVcpus": "'"#{Chef::Config[:knife][:cpu].to_s}"'",
          "hypervisorType": "Acropolis",
          "description": "Created with knife-acropolis",
          "vmDisks": [
            {
              "isCdrom": false,
              "isEmpty": false,
              "isScsiPassThrough": false,
              "vmDiskClone": {
                "vmDiskUuid": "e939e3b4-644d-4748-a96d-7f9128182ce2"
              }
            }
          ],
          "vmNics": [
            {
              "networkUuid": "c106f251-b858-4a8a-9db0-2fcd3b4ab105",
              "requestIp": true
            }
          ]
        }'
        task = post("/vms", specs)
        uuid = JSON.parse(task)
          task_list << uuid["taskUuid"].to_s
          print ui.list(task_list, :uneven_columns_across, 1)
      end
    end
  end
end
