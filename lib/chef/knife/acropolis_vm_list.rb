require 'chef/knife'

class Chef
  class Knife
    class AcropolisVm < Knife

      include AcropolisBase

      deps do
        require 'json'
      end

      banner 'knife acropolis vm list (options)'

      option :sorted,
      :short => '-S',
      :long => '--sorted',
      :boolean => true,
      :description => 'Getting a list of you acropolis VM´s sorted by name.'

      def run
        vms_list = [
          ui.color('VM UUID', :bold),
          ui.color('Name', :bold),
          ui.color('CPU', :bold),
          ui.color('RAM (MB)', :bold)
        ]

        if config[:sorted]
          vms = get('/vms')
          info = JSON.parse(vms)
          info['entities'].sort_by do |vm|
            [vm['config']['name'].downcase].compact
          end.each do |vm|
            vms_list << vm['uuid'].to_s
            vms_list << vm['config']['name']
            vms_list << vm['config']['numVcpus'].to_s
            vms_list << vm['config']['memoryMb'].to_s
          end
          print ui.list(vms_list, :uneven_columns_across, 4)
        else
          vms = get('/vms')
          info = JSON.parse(vms)
          info['entities'].each do |vm|
            vms_list << vm['uuid'].to_s
            vms_list << vm['config']['name']
            vms_list << vm['config']['numVcpus'].to_s
            vms_list << vm['config']['memoryMb'].to_s
          end
          print ui.list(vms_list, :uneven_columns_across, 4)
        end
      end
    end
  end
end
