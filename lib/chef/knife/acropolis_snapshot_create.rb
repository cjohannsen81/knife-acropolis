require 'chef/knife'

class Chef
  class Knife
    class AcropolisSnapshotCreate < Knife

      include AcropolisBase

      deps do
        require 'json'
        require 'securerandom'
      end

      banner "knife acropolis snapshot create (options)"

      option :uuid,
      :short => "-I ID",
      :long => "--vm-uuid ID",
      :description => "The VM UUID to take a snapshot on.",
      :proc => Proc.new { |i| Chef::Config[:knife][:uuid] = i }

      option :snap,
      :short => "-S NAME",
      :long => "--snap-name NAME",
      :description => "The name of the Snapshot.",
      :proc => Proc.new { |s| Chef::Config[:knife][:snap] = s }

      def validate
        unless  Chef::Config[:knife][:uuid] && Chef::Config[:knife][:snap]
          ui.error('Missing ID or Name. Use -I (--vm-uuid) to set the VM and -S (--snap-name) for the snapshot name.')
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
        specs = '{
          "snapshotSpecs": [
              {
              "vmUuid": "'"#{Chef::Config[:knife][:uuid].to_s}"'",
              "snapshotName":  "'"#{Chef::Config[:knife][:snap].to_s}"'",
              "uuid": "'"#{uuid}"'"
              }
            ]
        }'
        p specs
        task = post("/snapshots", specs)
        uuid = JSON.parse(task)
          task_list << uuid["taskUuid"].to_s
          print ui.list(task_list, :uneven_columns_across, 1)
      end
    end
  end
end
