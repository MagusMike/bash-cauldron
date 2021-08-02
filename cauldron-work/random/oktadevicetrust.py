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
# By default, Okta enforces a per-device enrollment limit on unbound certs that prevents organizations from enrolling any macOS device in this Device Trust solution more than five times for unbound certs.
# Any number of bound certs could be enrolled per device.
# Hitting the limit generates the error message: Maximum enrollment limit of 5 certificates for a device is reached.
# There may be cases when you need to override the default enrollment limit for certain devices, such as device issued more than 5 unbound certs.
# In those cases, to override the enrollment limit you must revoke and remove all the Device Trust certificates from the device as follows:
# Create an Okta API token for an Org Admin. Note: Be sure to make aPLUG
#  of the token for use later in this procedure.
# Needs Python2 - obtain the script from
# revoke internal script


import subprocess
import json


SERVER = 'https://company.okta.com'  # eg. 'https://<orgname>.okta.com'
ORG_API_TOKEN = ''  # eg. 'SSWS 00q6jBD9vjrQUjs8Gk2s8Tn6cyAdnfcsqD9'
MAC_UDID = open('/private/tmp/uuid.txt', 'r').read() # eg. '564D4B62-CE59-616C-D237-0F586BD3C4F0'


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
# In a text editor, modify the script by entering values in the following fields:


#SERVER-->    Enter the URL of your org. Be sure to retain the single quotation marks ('). For example, 'https://example.okta.com'
#ORG_API_TOKEN  -->  Enter 'SSWS <api-token>' where <api-token> is the API token you created in Step 2. Be sure to retain the single quotation marks ('). For example,'SSWS 00q3jBK9vjrQUjs8Gk2G2Yn6cyAdnfcsqA4iBQWrrnu'
#MAC_UDID    --> Enter the device UDID  Be sure to retain the single quotation marks ('). For example,'1C2514E3-CZ2C-5425-A0DD-01B48H7C2Q93'
#Save your changes.

#Execute the script to remove all the certificates associated with the macOS device.

#Also make sure that device is cleanup by running registration task with uninstall mode.
#cleanup
# Cleanup
#python MacOktaDeviceRegistrationTaskSetup.1.0.2.py uninstall

# Install again
#python MacOktaDeviceRegistrationTaskSetup.1.0.2.py
