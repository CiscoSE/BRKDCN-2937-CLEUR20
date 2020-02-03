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

import re
from pprint import pprint

def is_os_type_nxos(config_file,config_file_name):
    """
    :param config_file List
    :return detected_type Dictionary {"os_type": "undefined", "version": "undefined", "os_binary": "undefined"
    """
    detected_type = {"config_file_name": config_file_name, "os_type": "undefined", "version": "undefined", "os_binary": "undefined"}
    nxos_patterns = ["^boot nxos","^feature-set","^feature","^interface Ethernet","^vrf context", "^vrf context"]
    nxos_version_pattern ="^version"
    nxos_binary_pattern = "boot nxos"
    found_os = False
    for config_line in config_file:
        not_checked_all_patterns = True
        while not found_os and not_checked_all_patterns:
            i = 0
            for pattern in nxos_patterns:
                if re.match(pattern, config_line):
                    detected_type["os_type"] = "nxos"
                    found_os = True
                i = i + 1
            if i >= (len(nxos_patterns) - 1):
                not_checked_all_patterns = False
        if re.match(nxos_version_pattern, config_line):
            detected_type["version"] = config_line.split()[1]
        if re.match(nxos_binary_pattern, config_line):
            detected_type["os_binary"] = config_line.split(":")[1].lstrip().rstrip()
    if found_os:
        pprint (detected_type)
        return detected_type
    else: 
        return None

def is_os_type_ios(config_file,config_file_name):
    """
    :param config_file List
    :return detected_type Dictionary {"os_type": "undefined", "version": "undefined", "os_binary": "undefined"
    """
    detected_type = {"config_file_name": config_file_name, "os_type": "undefined", "version": "undefined", "os_binary": "undefined"}
    ios_patterns = ["boot system bootdisk:","^switch virtual domain","^interface TenGigabitEthernet","^access-list [0-9]+"]
    ios_version_pattern = "^version"
    ios_binary_pattern = "boot system bootdisk:"
    found_os = False
    for config_line in config_file:
        not_checked_all_patterns = True
        while not found_os and not_checked_all_patterns:
            i = 0
            for pattern in ios_patterns:
                if re.match(pattern, config_line):
                    detected_type["os_type"] = "ios"
                    found_os = True
                i = i + 1
            if i >= (len(ios_patterns) - 1):
                not_checked_all_patterns = False
        if re.match(ios_version_pattern, config_line):
            detected_type["version"] = config_line.split()[1]
        if re.match(ios_binary_pattern, config_line):
            detected_type["os_binary"] = config_line.split(":")[1].lstrip().rstrip()
    if found_os:
        return detected_type
    else: 
        return None

def detect_os_type_and_version(config_file,config_file_name):
    """
    Search OS type and Version specific patterns in a config file and return 
    the detect result in the form of a dictionnary.
    This function currently supports NXOS and IOS
    :param config_file: List where each list entry is a line of the configuration file
    :return  detected_type : Dictionary of the form  {"os_type": "", "version": "", "os_binary": ""}
    """
    check_nxos = is_os_type_nxos(config_file,config_file_name)
    if check_nxos:
        return check_nxos
    else:
        check_ios = is_os_type_ios(config_file, config_file_name)
        if check_ios:
            return check_ios
        else:
            return {"config_file_name": config_file_name, "os_type": "undefined", "version": "undefined", "os_binary": "undefined"}