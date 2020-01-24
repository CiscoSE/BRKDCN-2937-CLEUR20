# BRKDCN-2937-CLEUR20 - Discovery Playbooks

Sample Ansible playbook used for Discovery Demo during BRKDCN-2937 at Cisco Live Barcelona 2020

---

## File Structure

| File Path | Description |
| :-------- | :--------- |
| `inventory.yaml` | Inventory file listing devices to pull data from, credentials, etc. Actual device names, etc. have been replaced with "placeholder" values are enclosed within < > characters |
| `network-discovery.yaml`| The discovery playbook it self |
| `parsers/nxos/nxos_show_hsrp_brief_parser.yaml` | parse_cli script that uses regexp to "convert" NX-OS command output to Ansible variables |
| `parsers/nxos/nxos_show_ip_arp_parser.yaml` | parse_cli script that uses regexp to "convert" NX-OS command output to Ansible variables |
| `parsers/nxos/nxos_show_mac_address_table_parser.yaml` | parse_cli script that uses regexp to "convert" NX-OS command output to Ansible variables |
| `parsers/nxos/nxos_show_vrf_parser.yaml` | parse_cli script that uses regexp to "convert" NX-OS command output to Ansible variables |

## Tested Software Versions

For the discovery demo where the following software versions used:

* Ansible 2.9.1 (using Python 2.7.5)
* Cisco Nexus 9000 running NX-OS 7.0(3)I7(7)

## Installation

During the demo was Ansible running inside a docker container for ease of portability, but it could as well have run directly on a Linux host / VM.
