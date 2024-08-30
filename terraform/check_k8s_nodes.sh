#!/bin/bash

export KUBECONFIG=bruvio-config

# Function to check the status of all nodes
check_nodes_status() {
  # Get the status of all nodes
  node_status=$(kubectl get nodes | grep -v NAME | awk '{print $2}')

  # Check if all nodes are in the "Ready" state
  all_ready=true
  for status in $node_status; do
    if [ "$status" != "Ready" ]; then
      all_ready=false
      break
    fi
  done

  echo $all_ready
}

# Loop until all nodes are ready
while true; do
  all_ready=$(check_nodes_status)

  if [ "$all_ready" = true ]; then
    echo "All Kubernetes nodes are ready!"
    break
  else
    echo "Not all nodes are ready yet. Checking again in 10 seconds..."
    sleep 10
  fi
done
