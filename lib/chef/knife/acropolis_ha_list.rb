require 'chef/knife'

class Chef
  class Knife
    class AcropolisHa < Knife
      
      include AcropolisBase

      deps do
        require 'json'
      end

      banner "knife acropolis ha list (options)"

      def run    
        ha_list = [
          ui.color('Enabled', :bold),
          ui.color('Hosts', :bold),
          ui.color('HA State', :bold)
        ]
      
        ha = get("/ha")
        info = JSON.parse(ha)
        ha_list << info["failoverEnabled"].to_s
        ha_list << info["numHostFailuresToTolerate"].to_s
        ha_list << info["reservationType"].to_s
        print ui.list(ha_list, :uneven_columns_across, 3)
        
      end
    end
  end
end