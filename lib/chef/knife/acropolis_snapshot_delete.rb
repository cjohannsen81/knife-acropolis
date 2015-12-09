require 'chef/knife'

class Chef
  class Knife
    class AcropolisSnapshotDelete < Knife
      
      include AcropolisBase

      deps do
        require 'json'
      end

      banner "knife acropolis snapshot delete (options)"

      option :uuid,
      :short => "-S ID",
      :long => "--snap-uuid ID",
      :description => "The UUID of the snapshot to delete",
      :proc => Proc.new { |i| Chef::Config[:knife][:snapUuid] = i }
      
      def validate
        unless  Chef::Config[:knife][:snapUuid] 
          ui.error('Missing ID. Use -S (--snap-uuid) to set the snapshot ID for deletion. Use "knife acropolis snapshot list" to find the UUID.')
          exit 1
        end
      end

      def run    
        validate 
        
        specs = Chef::Config[:knife][:snapUuid].to_s
        p specs
        task = delete("/snapshots", specs)
        p task
      end
    end
  end
end