#!/bin/bash
set -e

defaultRun="sudo mn"

## Start OpenVSwitch
function startOvS {
  service openvswitch-switch start
  ovs-vsctl set-manager ptcp:6640
  sudo mn -c
}

## Clean Exit
function cleanExit {
  echo "*** Container Exiting..."
  service openvswitch-switch stop
  exit $1 | exit 0
}

echo "*** Container Starting..."
startOvS
clear

## Try and run using MN first
if [ -z "$MN_FLAGS" ]; then
  echo "*** No MN flags found... looking for a python file"
else
  echo "*** Running Mininet Using MN"
  sudo mn ${MN_FLAGS}
  cleanExit
fi

## Otherwise, try and use a python file
cd ${TOPO_DIR}
if [[ $(ls | grep "\.py$" | wc -l) -eq 1 ]]; then
  ## Try and run using file if not mn
  echo "*** Found file in ${TOPO_DIR}"
  echo "*** Running Mininet Using Python API"
  sudo python ${TOPO_DIR}/$(ls | grep "\.py$")
  cleanExit
elif [[ $(ls | grep "\.py$" | wc -l) -eq 0 ]]; then 
  ## Run default if no files found
  echo "*** !! No files found in ${TOPO_DIR} !! "
  echo "*** Running Mininet Using MN with no Flags"
  sudo mn
  cleanExit 0
else
  ## Run only the specified file
  if [ -z "$PY_FILE" ]; then
    ## Exit if too many files in topo dir and no specified file
    echo "*** !! There should only be 1 python file in ${TOPO_DIR} !! "
    cleanExit 1
  else
    if [ -f "${TOPO_DIR}/${PY_FILE}" ]; then
      echo "*** Running given py file... "
      sudo python ${TOPO_DIR}/$PY_FILE
    else
      ## Exit if too many files in topo dir and no specified file
      echo "*** !! Specified pyfile does not exist in ${TOPO_DIR} !! "
      cleanExit 1
    fi
  fi
fi
