# Copyright (c) 2020 Cisco and/or its affiliates.
#
# This software is licensed to you under the terms of the Cisco Sample
# Code License, Version 1.1 (the "License"). You may obtain a copy of the
# License at
#
#                https://developer.cisco.com/docs/licenses
#
# All use of the material herein must be in accordance with the terms of
# the License. All rights not expressly granted by the License are
# reserved. Unless required by applicable law or agreed to separately in
# writing, software distributed under the License is distributed on an "AS
# IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
# or implied.

*** Settings ***
Library          CXTA
Resource         cxta.robot
Suite Setup      Setup
Suite Teardown   Teardown

*** Variables ***
${REMOTE_URL}    http://selenium:4444/wd/hub
${site}          http://brkdcn-2937.cisco.com/
${apic}          dcv-apic-pod5-1

*** Keywords ***
Setup
    [Documentation]  Load testbed file, connect to all devices, and launch selenium browser
    use testbed "testbed.yaml"
    connect to device "DCV-N9372PX-1"
    connect to device "DCV-N9372PX-2"
    Start Browser    browser_name=chrome  remote_url=${REMOTE_URL}
    set browser timeout to "3" seconds
    Embed Screenshots

Teardown
    [Documentation]  Disconnect from all devices and close selenium browser
    disconnect from all devices
    Close Browser

*** Test Cases ***
Verify IP Interface Status
    [Documentation]   Verify Existing IP Interface is up
    ${devices} =      Create List     DCV-N9372PX-1      DCV-N9372PX-2
    ${cmd} =          Set Variable    show ip interface vlan 130
    : FOR  ${device}  IN  @{devices}
    \  ${output} =      execute command "${cmd}" on device "${device}"
    \  Run keyword And Continue on Failure   Should Contain        ${output}   protocol-up/link-up/admin-up   SVI Interface are not up on ${device}                      values=false

Verify HSRP
    [Documentation]   Verify Existing HSRP is active
    ${cmd} =          Set Variable    show hsrp interface vlan 130 brief
    ${output} =       execute command "${cmd}" on device "DCV-N9372PX-1"
    Run keyword And Continue on Failure      Should Contain       ${output}    Active                       DCV-N9372PX-1 are not the active node                        values=false
    Run keyword And Continue on Failure      Should Contain       ${output}    100.64.130.3                 100.64.130.3 are not the standby node on DCV-N9372PX-1       values=false
    ${output} =       execute command "${cmd}" on device "DCV-N9372PX-2"
    Run keyword And Continue on Failure      Should Contain       ${output}    Standby                      DCV-N9372PX-2 are not the standby node                       values=false
    Run keyword And Continue on Failure      Should Contain       ${output}    100.64.130.2                 100.64.130.2 are not the active node on DCV-N9372PX-1        values=false

Verify Reachability
    [Documentation]  Verify Reachability (ping) for Database VM
    ${devices} =      Create List     DCV-N9372PX-1      DCV-N9372PX-2
    ${cmd} =          Set Variable    ping 100.64.130.10 vrf BRKDCN_2937 count 5
    : FOR  ${device}  IN  @{devices}
    \  ${output} =      execute command "${cmd}" on device "${device}"
    \  Run keyword And Continue on Failure   Should not Contain     ${output}   100.00% packet loss                                         Endpoint not responding to ping from devide ${device}                     values=false

Verify ARP Table
    [Documentation]   Verify Existing Network has an ARP Entry
    ${devices} =      Create List     DCV-N9372PX-1      DCV-N9372PX-2
    ${cmd} =          Set Variable    show ip arp 100.64.130.10 vrf BRKDCN_2937
    : FOR  ${device}  IN  @{devices}
    \  ${output} =      execute command "${cmd}" on device "${device}"
    \  Should not contain                    ${output}             Total number of entries: 0               No ARP entry found on ${device}                              values=false
    \  Run keyword And Continue on Failure   Should Contain        ${output}   Total number of entries: 1   More than one ARP entry found on ${device}                   values=false
    \  Run keyword And Continue on Failure   Should Contain        ${output}   0050.5683.1ab4               ARP Entry does not match expected MAC Address on ${device}   values=false
    \  Run keyword And Continue on Failure   Should Contain        ${output}   Vlan130                      ARP Entry does not match expected interface on ${device}     values=false

Verify MAC Address Table
    [Documentation]   Verify Existing Network has an MAC Entry
    ${devices} =      Create List     DCV-N9372PX-1      DCV-N9372PX-2
    ${cmd} =          Set Variable    show mac address-table address 0050.5683.1ab4 vlan 130
    : FOR  ${device}  IN  @{devices}
    \  ${output} =      execute command "${cmd}" on device "${device}"
    \  Run keyword And Continue on Failure   Should Contain        ${output}   Po100                        MAC Entry does not match expected interface on ${device}     values=false
    \  Run keyword And Continue on Failure   Should Contain        ${output}   dynamic                      MAC Entry are not learnt dynamically on ${device}            values=false

Verify Website
    [Documentation]  Access Website and verify page header
    visit "${site}"
    wait for the page to load via XPath "/html/head/title"
    check if the title of the page is "BRKDCN-2937"
    Save Screenshot