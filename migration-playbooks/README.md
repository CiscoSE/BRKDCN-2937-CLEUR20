# BRKDCN-2937-CLEUR20 - Migration Playbooks

Sample Ansible playbook used for Migration Demo during BRKDCN-2937 at Cisco Live Barcelona 2020

---

## File Structure

| File Path | Description |
| :-------- | :--------- |
| `inventory.yaml` | Inventory file listing devices to pull data from, credentials, etc. Actual device names, etc. have been replaced with "placeholder" values are enclosed within < > characters |
| `pre-migration-configuration.yaml`| Playbook for appling pre-migration configuratino to ACI (create BD, EPG, EPG Bindings, etc.) |
| `l2-migration.yaml`| Playbook for performing the Layer-2 migration step (VM move from a network point of view) |
| `l3-migration.yaml`| Playbook for performing Layer-3 migration step (move subnet from current network to ACI) |
| `rollback-pre-migration-config.yaml`| Playbook for rolling back / deleting pre-migration configuration in ACI (BD, EPG, etc.) |
| `l3-migration.yaml`| Playbook for rolling back the Layer-2 migration step (VM move from a network point of view) |
| `l3-migration.yaml`| Playbook for rolling back the Layer-3 migration step (move subnet from current network to ACI) |

Please note that the playbooks in this directory contains hardcoded names of ACI Objects (BD, EPG, Contracts, etc.) as well as hardcoded IP and MAC addresses.

## Tested Software Versions

For the discovery demo where the following software versions used:

* Ansible 2.9.1 (using Python 2.7.5)
* VMware vSphere version 6.7
* Cisco Nexus 9000 running NX-OS 7.0(3)I7(7)
* Cisco ACI running 4.2(2f)

## Installation

During the demo was Ansible running inside a docker container for ease of portability, but it could as well have run directly on a Linux host / VM.
