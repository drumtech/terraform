# Common info about how it works

There are three variants how we can get ssh-key owned by REBRAIN.SSH.PUB.KEY

###### ***First variant***

We can use a python script. To do this, we need to add local variables local.ssh_rebrain_py to the ssh_keys list.

###### ***Second variant***

We can use a bash script. To do this, we need to add local variables local.ssh_rebrain_bash to the ssh_keys list.

###### ***Third variant***

Or if we don't want to use either python or bash. To do this, we need to add local variables local.our_keys[0] to the ssh_keys list.
