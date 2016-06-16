require 'chef/knife'

class Chef
  class Knife
    class AcropolisTask < Knife

      include AcropolisBase

      deps do
        require 'json'
      end

      banner 'knife acropolis task list (options)'

      option :completed,
      :short => '-C',
      :long => '--completed',
      :boolean => true,
      :description => 'Getting a list of your Snaphots sorted by Snapshot name.'

      def run
        task_list = [
          ui.color('UUID', :bold),
          ui.color('Operation', :bold),
          ui.color('Status', :bold),
          ui.color('VM-UUID', :bold),
          ui.color('Type', :bold)
        ]

        if config[:completed]
          tasks = get('/tasks/?includeCompleted=true')
          info = JSON.parse(tasks)
          info['entities'].each do |task|
            task_list << task['uuid'].to_s
            task_list << task['operationType'].to_s
            task_list << task['progressStatus'].to_s
            task_list << task['entityList'][0]['uuid']
            task_list << task['entityList'][0]['entityType']
          end
          print ui.list(task_list, :uneven_columns_across, 5)
        else
          tasks = get('/tasks')
          info = JSON.parse(tasks)
          if info['entities'].any?
            info['entities'].each do |task|
              task_list << task['uuid'].to_s
              task_list << task['operationType'].to_s
              task_list << task['progressStatus'].to_s
              task_list << task['entityList'][0]['uuid']
              task_list << task['entityList'][0]['entityType']
            end
            print ui.list(task_list, :uneven_columns_across, 5)
          else
            ui.error('no actual tasks, using -C shows completed tasks')
          end
        end
      end
    end
  end
end
