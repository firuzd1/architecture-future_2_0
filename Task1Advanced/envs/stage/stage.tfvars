env       = "stage"
cloud_id  = "b1g96naop0ovlm01etik"
folder_id = "b1gp7vpvsk1ru9j8m0hg"
zone      = "ru-central1-a"
subnet_id = "e9bqisvoo4nfkthe4pno"

cores          = 2
memory         = 4
core_fraction  = 50
preemptible    = true
boot_disk_size = 15
data_disk_size = 20
data_disk_type = "network-hdd"

ssh_public_key_path = "~/.ssh/id_ed25519.pub"
