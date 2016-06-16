require 'chef/knife'

class Chef
  class Knife
    #Class for Acroplis VM creation
    class AcropolisVmCreate < Knife
      include AcropolisBase

      deps do
        require 'json'
        require 'securerandom'
      end

      banner 'knife acropolis vm create (options)'

      option :mem,
             short: '-M MB',
             long: '--mem MB',
             description: 'Memory in MegaBytes',
             proc: proc { |i| Chef::Config[:knife][:mem] = i }

      option :cpu,
             short: '-C CORES',
             long: '--cpu CORES',
             description: 'CPU cores',
             proc: proc { |i| Chef::Config[:knife][:cpu] = i }

      option :disk_size,
             short: '-D MB',
             long: '--disk-size MB',
             description: 'Disk Size in MB',
             proc: proc { |i| Chef::Config[:knife][:disk_size] = i }

      option :networkUuid,
             short: '-U UUID',
             long: '--network-uuid UUID',
             description: 'Network UUID',
             proc: proc { |i| Chef::Config[:knife][:networkUuid] = i }

      option :chef_node_name,
             short: '-N NAME',
             long: '--node-name NAME',
             description: 'The Chef node name for your new node',
             proc: proc { |key| Chef::Config[:knife][:node_name] = key }

      def validate
        unless  Chef::Config[:knife][:mem] && Chef::Config[:knife][:cpu] && Chef::Config[:knife][:disk_size] && Chef::Config[:knife][:networkUuid] && Chef::Config[:knife][:node_name]
          ui.error('Missing mem, cpu, name or gateway. Use -M (--mem), -C (--cpu), -N (--node-name), -D (--disk-size) and -U (--network-uuid) to set the mandatory values.')
          exit 1
        end
      end

      def run
        validate

        task_list = [
          ui.color('Task ID', :bold)
        ]

        specs = '{
          "name": "'"#{Chef::Config[:knife][:node_name]}"'",
          "memoryMb": "'"#{Chef::Config[:knife][:mem]}"'",
          "numVcpus": "'"#{Chef::Config[:knife][:cpu]}"'",
          "hypervisorType": "Acropolis",
          "description": "Created with knife-acropolis",
          "vmDisks": [
            {
              "isCdrom": false,
              "isEmpty": false,
              "isScsiPassThrough": false,
              "vmDiskCreate": {
                "containerName": "default",
                "sizeMb": "'"#{Chef::Config[:knife][:disk_size]}"'"
              }
            }
          ],
          "vmNics": [
            {
              "networkUuid": "'"#{Chef::Config[:knife][:networkUuid]}"'",
              "requestIp": true
            }
          ]
        }'
        task = post('/vms', specs)
        uuid = JSON.parse(task)
        task_list << uuid['taskUuid'].to_s
        print ui.list(task_list, :uneven_columns_across, 1)
      end
    end
  end
end
