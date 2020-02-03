# BRKDCN-2937-CLEUR20 - Discovery Playbooks

Sample Python scripts used for Discovery AnalysisDemo during BRKDCN-2937 at Cisco Live Barcelona 2020

---

## File Structure

| File Path | Description |
| :-------- | :--------- |
| `analysis-state.py` | Python script to analyse discovered state. Output is controlled using `composer.yaml` |
| `composer.yaml`| File that controls which Sheets to create and which columns to include in each sheet when executing the `analysis-state.py`Python script |
| `nxos_config_parser.py`| Python script to analyse NXOS configuration backups. |
| `detect_os_type_and_version` | Helper Python script that are invoked through the `nxos_config_parser.py` script |
| `requirements.txt` | Requirements file specifying the Python modules required |

## Tested Software Versions

For the discovery demo where the following software versions used:

* Python 3.6.8)
* Cisco Nexus 9000 running NX-OS 7.0(3)I7(7)

## Installation

During the demo was Python running inside a docker container for ease of portability, but it could as well have run directly on a Linux host / VM.
