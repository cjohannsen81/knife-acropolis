require 'chef/knife'

class Chef
  class Knife
    class AcropolisVdisk < Knife

      include AcropolisBase

      deps do
        require 'json'
      end

      banner 'knife acropolis vdisk list (options)'

      option :completed,
      :short => '-N NAME',
      :long => '--ndfs NAME',
      :boolean => true,
      :description => 'Name of the NDFS path to look for (root is /)',
      :proc => Proc.new { |p| Chef::Config[:knife][:path] = p }


      def validate
        unless  Chef::Config[:knife][:path]
          ui.error('Missing path. Use -N (--ndfs) to check vdisks. Root path is '/' for all.')
          exit 1
        end
      end

      def run
        validate

        vdisk_list = [
          ui.color('Name', :bold),
          ui.color('Size', :bold),
          ui.color('Used', :bold),
          ui.color('File-Type', :bold),
          ui.color('File-Path', :bold),
        ]

        path = Chef::Config[:knife][:path].sub! '/', '%2F'
        vdisk = get('/vdisks/?path='+path)
        info = JSON.parse(vdisk)
        info['entities'].sort_by do
          vdisk_list << vdisk['name'].to_s
          vdisk_list << vdisk['totalSize'].to_s
          vdisk_list << vdisk['usedSize'].to_s
          vdisk_list << vdisk['fileType'].to_s
          vdisk_list << vdisk['filePath'].to_s
        end
        print ui.list(vdisk_list, :uneven_columns_across, 5)
      end
    end
  end
end
