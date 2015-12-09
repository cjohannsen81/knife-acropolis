require 'chef/knife'

class Chef
  class Knife
    class AcropolisNetwork < Knife
      
      include AcropolisBase

      deps do
        require 'json'
      end

      banner "knife acropolis network list (options)"

      def run
        $stdout.sync = true
        
        network_list = [
          ui.color('UUID', :bold),
          ui.color('VLAN ID', :bold),
          ui.color('IP Address', :bold),
          ui.color('Prefix', :bold),
          ui.color('Gateway', :bold) 
        ]
    
        networks = get("/networks")
          info = JSON.parse(networks)
          info["entities"].each do |network|
            network_list << network["uuid"].to_s
            network_list << network["vlanId"].to_s
            network_list << network["ipConfig"]["networkAddress"].to_s
            network_list << network["ipConfig"]["prefixLength"].to_s
            network_list << network["ipConfig"]["defaultGateway"].to_s
          end
        print ui.list(network_list, :uneven_columns_across, 5)
      end
    end
  end
end