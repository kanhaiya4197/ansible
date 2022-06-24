provider "vsphere" {	    user = "username"	        password = "password"	        vsphere_server = "labbvcenter.infralab.zone"	        allow_unverified_ssl = true	}	data "vsphere_datacenter" "datacenter" {	    name = "LAB MGMT"	}	data "vsphere_datastore" "datastore" {	    name = "RAL-VM-CS210-HYBD-02"	        datacenter_id = data.vsphere_datacenter.datacenter.id	}	data "vsphere_compute_cluster" "cluster" {	    name = "LAB MGMT Cluster"	        datacenter_id = data.vsphere_datacenter.datacenter.id	}	data "vsphere_network" "network" {	    name = "VMN VLAN 2251"	        datacenter_id = data.vsphere_datacenter.datacenter.id	}	data "vsphere_virtual_machine" "template" {	    name = "UBUNTU 18.04 SERVER TEMPLATE (17-JUNE-2020)"	        datacenter_id = data.vsphere_datacenter.datacenter.id	}	resource "vsphere_virtual_machine" "vm" {	    name = "ssp-test1"	        annotation = "SSP-TEST Owners: Solutions Engineering"	        folder = "/Terraform"	        resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id	        datastore_id = data.vsphere_datastore.datastore.id	        num_cpus = 2	        memory = 8192	        wait_for_guest_net_timeout = 15	        guest_id = data.vsphere_virtual_machine.template.guest_id	        scsi_type = data.vsphere_virtual_machine.template.scsi_type	        network_interface {	        network_id = data.vsphere_network.network.id	            adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]	    }	    disk {	        label = "disk0"	            size = data.vsphere_virtual_machine.template.disks.0.size	            eagerly_scrub = data.vsphere_virtual_machine.template.disks.0.eagerly_scrub	            thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned	    }	    clone {	        template_uuid = data.vsphere_virtual_machine.template.id	            customize {	            linux_options {	                host_name = "ssp-test1"	                    domain = "infralab.zone"	            }	            network_interface {}	        }	    }	}	