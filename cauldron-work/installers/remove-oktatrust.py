#!/usr/bin/python
 
#
# Copyright 2018-present, Okta Inc.
#
# Script to revoke client certificates per device
#
# https://help.okta.com/en/prod/Content/Topics/Miscellaneous/Third-party%20Licenses/3rd%20Party%20Notices_Okta%20Password%20Sync%20Setup.pdf
#
# APIs used in this process are internal APIs and they are subject to changes without prior notice.
#

import sys
import subprocess
import json
import objc
 
SERVER = 'https://wellframe.okta.com' 
ORG_API_TOKEN = 'SSWS 00KxQ3o5t0dIBunfWr-968IkoPyAN6WRKhIDkUI0gw'
#### this will be parameter 5 in JAMF  
#MAC_UDID =  sys.argv[5] #'CE5834E5-08A6-5F08-84CB-7574586FD849' 

##############################################################

from Foundation import NSBundle

IOKit_bundle = NSBundle.bundleWithIdentifier_('com.apple.framework.IOKit')

functions = [("IOServiceGetMatchingService", b"II@"),
             ("IOServiceMatching", b"@*"),
             ("IORegistryEntryCreateCFProperty", b"@I@@I"),
            ]

objc.loadBundleFunctions(IOKit_bundle, globals(), functions)

def io_key(keyname):
    return IORegistryEntryCreateCFProperty(IOServiceGetMatchingService(0, IOServiceMatching("IOPlatformExpertDevice")), keyname, None, 0)

def get_hardware_uuid():
    return io_key("IOPlatformUUID")
    return MAC_UDID

################################################################
 
MAC_UDID = get_hardware_uuid()

################################################################
 

def get_and_revoke_certs():
    url = '%s/api/v1/internal/devices/%s/credentials/keys' % (SERVER, MAC_UDID)
    print 'Getting certs for device: ' + MAC_UDID
    response = subprocess.check_output(['curl', '-sS', '-X', 'GET',
                                        '-H', 'Authorization: ' + ORG_API_TOKEN,
                                        url])
    print 'Response: ' + response
    data = json.loads(response)
    if not data:
        print 'No certs found'
        exit(0)
    for key in data:
        if 'kid' not in key:
            print "Error response."
            exit(1)
        revoke_cert(key['kid'])
    print 'Finished'
 
 
def revoke_cert(kid):
    url = '%s/api/v1/internal/devices/%s/keys/%s/lifecycle/revoke' % (SERVER, MAC_UDID, kid)
    print "Revoking certificate: " + kid
    response = subprocess.check_output(['curl', '-sS', '-X', 'POST',
                                        '-H', 'Authorization: ' + ORG_API_TOKEN,
                                        url])
    print 'Response: ' + response
 
def check_params():
    if not SERVER:
        print "SERVER can't be empty, please populate org URL eg. https://&lt;org>.okta.com"
        exit(1)
    if not ORG_API_TOKEN:
        print "ORG_API_TOKEN can't be empty, please assign API token eg. SSWS <API-Token>"
        exit(1)
    if not MAC_UDID:
        print "MAC_UDID can't be empty, please assign macOS UDID"
        exit(1)
 
check_params()
get_and_revoke_certs()
