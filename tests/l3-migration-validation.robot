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
    [Documentation]   Verify Existing IP Interface is down
    ${devices} =      Create List     DCV-N9372PX-1      DCV-N9372PX-2
    ${cmd} =          Set Variable    show ip interface vlan 130
    : FOR  ${device}  IN  @{devices}
    \  ${output} =      execute command "${cmd}" on device "${device}"
    \  Run keyword And Continue on Failure   Should Contain        ${output}   protocol-down/link-down/admin-down   SVI Interface are not down on ${device}                values=false

Verify HSRP
    [Documentation]   Verify Existing HSRP is inactive
    ${devices} =      Create List     DCV-N9372PX-1      DCV-N9372PX-2
    ${cmd} =          Set Variable    show hsrp interface vlan 130 brief
    : FOR  ${device}  IN  @{devices}
    \  ${output} =      execute command "${cmd}" on device "${device}"
    \  Run keyword And Continue on Failure   Should Contain        ${output}   Initial                      HSRP not in initial state on device ${device}                values=false
    \  Run keyword And Continue on Failure   Should Contain        ${output}   unknown                      HSRP Active/Standby node not unknown on device ${device}     values=false

Verify Reachability
    [Documentation]  Verify Reachability (ping) for Database VM
    ${devices} =      Create List     DCV-N9372PX-1      DCV-N9372PX-2
    ${cmd} =          Set Variable    ping 100.64.130.10 vrf BRKDCN_2937 count 5
    : FOR  ${device}  IN  @{devices}
    \  ${output} =      execute command "${cmd}" on device "${device}"
    \  Run keyword And Continue on Failure   Should not Contain     ${output}   100.00% packet loss                                         Endpoint not responding to ping from devide ${device}                     values=false

Verify ARP Table
    [Documentation]   Verify Existing Network has no ARP Entry
    ${devices} =      Create List     DCV-N9372PX-1      DCV-N9372PX-2
    ${cmd} =          Set Variable    show ip arp 100.64.130.10 vrf BRKDCN_2937
    : FOR  ${device}  IN  @{devices}
    \  ${output} =      execute command "${cmd}" on device "${device}"
    \  Run keyword And Continue on Failure   Should Contain        ${output}   Total number of entries: 0   ARP Entry still present on devide ${device}                   values=false

Verify ACI Endpoint Table
    [Documentation]  Verify Endpoint Entry for Database VM
    ${uri} =     Set Variable   /api/node/mo/uni/tn-BRKDCN-2937/ap-wordpress/epg-db/cep-00:50:56:83:1A:B4
    ${filter} =  Set Variable   rsp-subtree=full&rsp-subtree-class=fvRsCEpToPathEp
    ${output} =  via filtered ACI REST API retrieve "${uri}" using filter "${filter}" from "${apic}" as "object"
    Should Be Equal as Integers              ${output.totalCount}   1                                                                       Endpoint not found            values=false
    Run keyword And Continue on Failure      Should Contain         ${output.payload[0].fvCEp.attributes.lcC}                               vmm                           Endpoint not learned via VMM integration     values=false
    Run keyword And Continue on Failure      Should Contain         ${output.payload[0].fvCEp.children[0].fvRsCEpToPathEp.attributes.tDn}   dcv-ucs-c220-m4-9-pc_polgrp   Endpoint not learned on expected interface   values=false
    ${endpoint_paths} =                      Get Length             ${output.payload[0].fvCEp.children}
    Run Keyword if   ${endpoint_paths} > 1   Run Keyword
    ...  Fail   Endpoint seen on multiple interfaces, please investigate manually 

Verify Website
    [Documentation]  Access Website and verify page header
    visit "${site}"
    wait for the page to load via XPath "/html/head/title"
    check if the title of the page is "BRKDCN-2937"
    Save Screenshot