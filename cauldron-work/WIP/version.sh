#!/bin/bash

##### GRAB Applicaiton version and set as extension attribute

status1=$(mdls -name kMDItemVersion /Applications/zoom.us.app | cut -c 19-24)
status2=$(mdls -name kMDItemVersion /Applications/Slack.app | cut -c 19-24)
status3=$(mdls -name kMDItemVersion /Applications/Google\ Chrome.app | cut -c 19-31)
status4=$(mdls -name kMDItemVersion /Applications/OpenVPN\ Connect/OpenVPN\ Connect.app  | cut -c 19-24)
status5=$(mdls -name kMDItemVersion /Applications/Firefox.app  | cut -c 19-24)


if [[ ! -z ${status1} ]]; then
  echo "<result>${status1}</result>"
else
  echo "<result>status not found</result>" 
fi

if [[ ! -z ${status2} ]]; then
  echo "<result>${status2}</result>"
else
  echo "<result>status not found</result>" 
fi

if [[ ! -z ${status3} ]]; then
  echo "<result>${status3}</result>"
else
  echo "<result>status not found</result>" 
fi

if [[ ! -z ${status4} ]]; then
  echo "<result>${status4}</result>"
else
  echo "<result>status not found</result>" 
fi

if [[ ! -z ${status5} ]]; then
  echo "<result>${status5}</result>"
else
  echo "<result>status not found</result>" 
fi

