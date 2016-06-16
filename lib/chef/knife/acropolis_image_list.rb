require 'chef/knife'

class Chef
  class Knife
    class AcropolisImage < Knife
     #Acropolis Image List
      include AcropolisBase

      deps do
        require 'json'
      end

      banner 'knife acropolis image list (options)'

      def run
        im_list = [
          ui.color('UUID', :bold),
          ui.color('Name', :bold),
          ui.color('Type', :bold),
          ui.color('State', :bold)
        ]

        ha = get('/images')
        info = JSON.parse(ha)
        info['entities'].sort_by do |image|
          im_list << image['uuid'].to_s
          im_list << image['name'].to_s
          im_list << image['imageType'].to_s
          im_list << image['imageState'].to_s
        end
        print ui.list(im_list, :uneven_columns_across, 4)
      end
    end
  end
end
