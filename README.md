Knife Nutanix Acropolis
======

This is an unofficial Chef Knife plugin for the Nutanix Acropolis Hypervisor. This plugin allows to collect the informations available in the Management API.

# Installation #

If you already downloaded ChefDK you can easily install the gem using:

	$ chef gem install knife-acropolis

You can alternatively add this plugin to you normal knife plugin path (like ~/.chef/plugins/knife/) or download it natively as a gem:

	$ gem install knife-acropolis

Depending on your system's configuration, you may need to run this command with root privileges.

The simplest way to test the installation is to pass your host (-H), username (-U) and password (-P) with one of the available commands:

	knife acropolis ha list (options)
	knife acropolis image list (options)
	knife acropolis network list (options)
	knife acropolis snapshot create (options)
	knife acropolis snapshot delete (options)
	knife acropolis snapshot list (options)
	knife acropolis task list (options)
	knife acropolis vdisk list (options)
	knife acropolis vm clone (options)
	knife acropolis vm create (options)
	knife acropolis vm list (options)

You can also add the static options like host, username and password to your knife.rb configuration:

	knife[:a_host] = "yourhost.com"
	knife[:a_user] = "yourUsername"
	knife[:a_pass] = "yourPassword"

# Subcommands #

knife acropolis ha list
-----------------------

This command shows the actual HA state of the cluster.

knife acropolis image list
--------------------------

This command shows all images (ISO/Disk) available.

knife acropolis network list
----------------------------

This command shows all available networks.

knife acropolis network create
-----------------------

This command allows you to create a simple network.

knife acropolis snapshot create
-------------------------------

This command allows you to create a snapshot using (-I) for the VM UUID (you can find with "knife acropolis vm list") and (-N) for the snapshot name. The uuid for the snapshot is auto-generated.

knife acropolis snapshot delete
-------------------------------

This command allows you to delete a snapshot using (-S) for the Snapshot UUID (you can find with "knife acropolis snapshot list").

knife acropolis snapshot list
-----------------------------

This command shows all available snapshots in the cluster.

knife acropolis task list
-------------------------

This command shows all the actual tasks. When using (-C) all completed tasks will be shown as well.

knife acropolis vdisk list
--------------------------

This command shows all available vdisks in a path. You have to use (-N) to set the NDFS path. Using "/" shows the root path.

knife acropolis vm list
-----------------------

This command shows all available virtual machines in the cluster. Adding (-S) will show them sorted by name.

knife acropolis vm create
-----------------------

This command allows to create a virtual machine.

knife acropolis vm clone
-----------------------

This command allows to clone a virtual machine.


# License #

Author: Christian Johannsen (c.johannsen@clickedways.de)
License: Apache License, Version 2.0
