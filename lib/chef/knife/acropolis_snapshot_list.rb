require 'chef/knife'

class Chef
  class Knife
    class AcropolisSnapshotList < Knife

      include AcropolisBase

      deps do
        require 'json'
      end

      banner "knife acropolis snapshot list (options)"

      option :sorted,
      :short => '-S',
      :long => '--sorted',
      :boolean => true,
      :description => "Getting a list of your Snaphots sorted by Snapshot name."


      def run
        snap_list = [
          ui.color('Snap-UUID', :bold),
          ui.color('Snap-Name', :bold),
          ui.color('Deleted', :bold),
          ui.color('VM-UUID', :bold),
          ui.color('VM-Name', :bold)
        ]

        if config[:sorted]
          snap = get("/snapshots")
          info = JSON.parse(snap)
          info["entities"].sort_by do
            [snap["snapshotName"].to_s.downcase].compact
          end.each do
            snap_list << snap["uuid"]
            snap_list << snap["snapshotName"]
            snap_list << snap["deleted"].to_s
            snap_list << snap["vmUuid"]
            snap_list << snap["vmCreateSpecification"]["name"]
          end
          print ui.list(snap_list, :uneven_columns_across, 5)

        else
          snap = get("/snapshots")
          info = JSON.parse(snap)
          info["entities"].each do 
            snap_list << snap["uuid"]
            snap_list << snap["snapshotName"]
            snap_list << snap["deleted"].to_s
            snap_list << snap["vmUuid"]
            snap_list << snap["vmCreateSpecification"]["name"]
          end
          print ui.list(snap_list, :uneven_columns_across, 5)
        end

      end
    end
  end
end
