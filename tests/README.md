# BRKDCN-2937-CLEUR20 - Discovery Playbooks

Sample CXTA test suite used for Migration Demo during BRKDCN-2937 at Cisco Live Barcelona 2020

---

## File Structure

| File Path | Description |
| :-------- | :--------- |
| `pre-migration-validation.robot` | Pre-migration test suite |
| `l2-migration-validation.robot`| Test suite for verifying L2 migration |
| `l3-migration-validation.robot` | Test suite for verifying L3 migration |
| `testbed.yaml` | Testbed file defining the devices against which the test suite should be run as well as the login credentials to use |

As mentioned during the sessions are the test suites executed using Cisco CX Test Automation (CXTA), which are a Cisco internal tool based on Robot Frameworks. This means that not all the keywords used in the test suites are available within Robot Frameworks.

## Tested Software Versions

For the discovery demo where the following software versions used:

* CXTA 19.13 (based on Robot Frameworks 3.1.2)
* Selenium 3.141.0 (using Chrome)
* Cisco Nexus 9000 running NX-OS 7.0(3)I7(7)
* Cisco ACI running 4.2(2f)
