require 'chef/knife'

class Chef
  class Knife
    class AcropolisVmClone < Knife
      include AcropolisBase

      deps do
        require 'json'
      end

      banner 'knife acropolis vm clone (options)'

      option :mem,
             short: '-M MB',
             long: '--mem MB',
             description: 'Memory in MegaBytes',
             proc: proc { |i| Chef::Config[:knife][:mem] = i }

      option :cpu,
             short: '-C CPUS',
             long: '--cpu CPUS',
             description: 'Number of CPU Cores',
             proc: proc { |i| Chef::Config[:knife][:cpu] = i }

      option :source_vm,
             long: '--source_vm UUID',
             description: 'UUID of vm to clone',
             proc: proc { |i| Chef::Config[:knife][:source_vm] = i }

      option :chef_node_name,
             short: '-N NAME',
             long: '--node-name NAME',
             description: 'The Chef node name for your new node',
             proc: proc { |key| Chef::Config[:knife][:node_name] = key }

      option :bootstrap_protocol,
             long: '--bootstrap-protocol protocol',
             description: "Protocol to bootstrap windows servers. options: 'winrm' or 'ssh' or 'cloud-api'.",
             default: 'ssh'

      def validate
        unless Chef::Config[:knife][:mem] && Chef::Config[:knife][:cpu] && Chef::Config[:knife][:source_vm] && Chef::Config[:knife][:node_name]
          ui.error('Missing mem, cpu, name or source VM. Use -M (--mem), -C (--cpu), -N (--node-name) and --source_vm UUID to set the mandatory values.')
          exit 1
        end
      end

      def run
        validate

        task_list = [
          ui.color('Task ID', :bold)
        ]

        vm_list = [
          ui.color('VM ID', :bold)
        ]

        vm_list << uuid
        time = Time.now.to_i
        specs = '{
          "specList": [
            {
              "name": "'"#{Chef::Config[:knife][:node_name]}"'",
              "memoryMb": "'"#{Chef::Config[:knife][:mem]}"'",
              "numVcpus": "'"#{Chef::Config[:knife][:cpu]}"'",
              "overrideNetworkConfig": false
            }
          ]
        }'
        vm = post("/vms/#{Chef::Config[:knife][:source_vm]}/clone", specs)
        print ui.list(vm_list, :uneven_columns_across, 1)
      end
    end
  end
end
