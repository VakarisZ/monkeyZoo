provider "google" {
  project = "guardicore-22050661"
  region  = "europe-west3"
  zone    = "europe-west3-a"
  credentials = "${file("guardicore-22050661-9d4e6c6672fc.json")}"
}

// Local variables
locals {
  default_windows="${google_compute_instance_template.ubuntu16.self_link}"
  default_ubuntu="${google_compute_instance_template.windows2016.self_link}"
}

variable "region" {
  default="europe-west3"
}

variable "zone" {
  default="europe-west3-a"
}

resource "google_compute_network" "monkeyzoo" {
  name                    = "monkeyzoo"
  auto_create_subnetworks = false
}

resource "google_compute_network" "tunneling" {
  name                    = "tunneling"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "monkeyzoo-main" {
  name            = "monkeyzoo-main"
  ip_cidr_range   = "10.2.2.0/24"
  region          = "europe-west3"
  network         = "${google_compute_network.monkeyzoo.self_link}"

}

resource "google_compute_subnetwork" "tunneling-main" {
  name            = "tunneling-main"
  ip_cidr_range   = "10.2.1.0/28"
  region          = "europe-west3"
  network         = "${google_compute_network.tunneling.self_link}"
}

resource "google_compute_instance_template" "ubuntu16" {
  name        = "ubuntu16"
  description = "Creates ubuntu 16.04 LTS servers at europe-west3-a."

  tags = ["test-machine", "ubuntu16", "linux"]

  machine_type         = "n1-standard-1"
  region               = "${var.region}"
  can_ip_forward       = false

  disk {
    source_image = "ubuntu-os-cloud/ubuntu-1604-lts"
    auto_delete = true
    boot = true
  }
  network_interface {
    subnetwork="monkeyzoo-main"
    access_config {
      // Cheaper, non-premium routing
      network_tier = "STANDARD"
    }
  }
  service_account {
    email ="terraform-google@guardicore-22050661.iam.gserviceaccount.com"
    scopes=["cloud-platform"]
  }
}

resource "google_compute_instance_template" "windows2016" {
  name        = "windows2016"
  description = "Creates windows 2016 core servers at europe-west3-a."

  tags = ["test-machine", "windows2016core", "windows"]

  machine_type         = "n1-standard-1"
  region               = "${var.region}"
  can_ip_forward       = false

  disk {
    source_image = "windows-cloud/windows-2016-core"
    auto_delete = true
    boot = true
  }
  network_interface {
    subnetwork="monkeyzoo-main"
    access_config {
      // Cheaper, non-premium routing
      network_tier = "STANDARD"
    }
  }
  service_account {
    email="terraform-google@guardicore-22050661.iam.gserviceaccount.com"
    scopes=["cloud-platform"]
  }
}

resource "google_compute_instance_from_template" "hadoop-2" {
  name         = "hadoop-2"
  source_instance_template = "${local.default_ubuntu}"
  network_interface {
    subnetwork="monkeyzoo-main"
    network_ip="10.2.2.2"
    access_config {
      // Cheaper, non-premium routing
      network_tier = "STANDARD"
    }
  }
}
resource "google_compute_instance_from_template" "hadoop-3" {
  name         = "hadoop-3"
  source_instance_template = "${local.default_windows}"
  network_interface {
    subnetwork="monkeyzoo-main"
    network_ip="10.2.2.3"
    access_config {
      // Cheaper, non-premium routing
      network_tier = "STANDARD"
    }
  }
}
resource "google_compute_instance_from_template" "elastic-4" {
  name         = "elastic-4"
    source_instance_template = "${local.default_ubuntu}"
  network_interface {
    subnetwork="monkeyzoo-main"
    network_ip="10.2.2.4"
    access_config {
      // Cheaper, non-premium routing
      network_tier = "STANDARD"
    }
  }
}
resource "google_compute_instance_from_template" "elastic-5" {
  name         = "elastic-5"
  source_instance_template = "${local.default_windows}"
  network_interface {
    subnetwork="monkeyzoo-main"
    network_ip="10.2.2.5"
    access_config {
      // Cheaper, non-premium routing
      network_tier = "STANDARD"
    }
  }
}
resource "google_compute_instance_from_template" "sambacry-6" {
  name         = "sambacry-6"
  source_instance_template = "${local.default_ubuntu}"
  network_interface {
    subnetwork="monkeyzoo-main"
    network_ip="10.2.2.6"
    access_config {
      // Cheaper, non-premium routing
      network_tier = "STANDARD"
    }
  }
}

/* WE NEED COSTOM 32-BIT UBUNTU FOR THIS MACHINE
resource "google_compute_instance_from_template" "sambacry-7" {
  name         = "sambacry-7"
  source_instance_template = "${local.default_ubuntu}"
  boot_disk {
    initialize_params {
      // Add custom image to cloud
      image = "ubuntu32"
    }
  }
}
*/
resource "google_compute_instance_from_template" "shellshock-8" {
  name         = "shellshock-8"
  source_instance_template = "${local.default_ubuntu}"

  network_interface {
    subnetwork="monkeyzoo-main"
    network_ip="10.2.2.8"
    access_config {
      // Cheaper, non-premium routing
      network_tier = "STANDARD"
    }
  }
}
resource "google_compute_instance_from_template" "tunneling-9" {
  name         = "tunneling-9"
  source_instance_template = "${local.default_ubuntu}"
  network_interface{
    subnetwork="tunneling-main"
    network_ip="10.2.1.9"
    access_config {
      // Cheaper, non-premium routing
      network_tier = "STANDARD"
    }
    
  }
  network_interface{
    subnetwork="monkeyzoo-main"
    network_ip="10.2.2.9"
    access_config {
      // Cheaper, non-premium routing
      network_tier = "STANDARD"
    }
  }
}

resource "google_compute_instance_from_template" "tunneling-10" {
  name         = "tunneling-10"
  source_instance_template = "${local.default_ubuntu}"
  network_interface{
    subnetwork="tunneling-main"
    network_ip="10.2.1.10"
    access_config {
      // Cheaper, non-premium routing
      network_tier = "STANDARD"
    }
  }
}


resource "google_compute_instance_from_template" "sshkeys-11" {
  name         = "sshkeys-11"
  source_instance_template = "${local.default_ubuntu}"
  network_interface {
    subnetwork="monkeyzoo-main"
    network_ip="10.2.2.11"
    access_config {
      // Cheaper, non-premium routing
      network_tier = "STANDARD"
    }
  }
}

resource "google_compute_instance_from_template" "sshkeys-12" {
  name         = "sshkeys-12"
  source_instance_template = "${local.default_ubuntu}"
  network_interface {
    subnetwork="monkeyzoo-main"
    network_ip="10.2.2.12"
    access_config {
      // Cheaper, non-premium routing
      network_tier = "STANDARD"
    }
  }
}
resource "google_compute_instance_from_template" "rdpgrinder-13" {
  name         = "rdpgrinder-13"
  source_instance_template = "${local.default_windows}"
  network_interface {
    subnetwork="monkeyzoo-main"
    network_ip="10.2.2.13"
    access_config {
      // Cheaper, non-premium routing
      network_tier = "STANDARD"
    }
  }
}

resource "google_compute_instance_from_template" "mimikatz-14" {
  name         = "mimikatz-14"
  source_instance_template = "${local.default_windows}"
  network_interface {
    subnetwork="monkeyzoo-main"
    network_ip="10.2.2.14"
    access_config {
      // Cheaper, non-premium routing
      network_tier = "STANDARD"
    }
  }
}

resource "google_compute_instance_from_template" "mimikatz-15" {
  name         = "mimikatz-15"
  source_instance_template = "${local.default_windows}"
  network_interface {
    subnetwork="monkeyzoo-main"
    network_ip="10.2.2.15"
    access_config {
      // Cheaper, non-premium routing
      network_tier = "STANDARD"
    }
  }
}

resource "google_compute_instance_from_template" "mssql-16" {
  name         = "mssql-16"
  source_instance_template = "${local.default_windows}"
  network_interface {
    subnetwork="monkeyzoo-main"
    network_ip="10.2.2.16"
    access_config {
      // Cheaper, non-premium routing
      network_tier = "STANDARD"
    }
  }
}

resource "google_compute_instance_from_template" "upgrader-17" {
  name         = "upgrader-17"
  source_instance_template = "${local.default_windows}"
  network_interface {
    subnetwork="monkeyzoo-main"
    network_ip="10.2.2.17"
    access_config {
      // Cheaper, non-premium routing
      network_tier = "STANDARD"
    }
  }
}
resource "google_compute_instance_from_template" "weblogic-18" {
  name         = "weblogic-18"
  source_instance_template = "${local.default_ubuntu}"
  network_interface {
    subnetwork="monkeyzoo-main"
    network_ip="10.2.2.18"
    access_config {
      // Cheaper, non-premium routing
      network_tier = "STANDARD"
    }
  }
}

resource "google_compute_instance_from_template" "weblogic-19" {
  name         = "weblogic-19"
  source_instance_template = "${local.default_windows}"
  network_interface {
    subnetwork="monkeyzoo-main"
    network_ip="10.2.2.19"
    access_config {
      // Cheaper, non-premium routing
      network_tier = "STANDARD"
    }
  }
}

resource "google_compute_instance_from_template" "smb-20" {
  name         = "smb-20"
  source_instance_template = "${local.default_windows}"
  network_interface {
    subnetwork="monkeyzoo-main"
    network_ip="10.2.2.20"
    access_config {
      // Cheaper, non-premium routing
      network_tier = "STANDARD"
    }
  }
}

resource "google_compute_instance_from_template" "scan-21" {
  name         = "scan-21"
  source_instance_template = "${local.default_ubuntu}"
  network_interface {
    subnetwork="monkeyzoo-main"
    network_ip="10.2.2.21"
    access_config {
      // Cheaper, non-premium routing
      network_tier = "STANDARD"
    }
  }
}

resource "google_compute_instance_from_template" "scan-22" {
  name         = "scan-22"
  source_instance_template = "${local.default_windows}"
  network_interface {
    subnetwork="monkeyzoo-main"
    network_ip="10.2.2.22"
    access_config {
      // Cheaper, non-premium routing
      network_tier = "STANDARD"
    }
  }
}
resource "google_compute_instance_from_template" "struts2-23" {
  name         = "struts2-23"
  source_instance_template = "${local.default_ubuntu}"
  network_interface {
    subnetwork="monkeyzoo-main"
    network_ip="10.2.2.23"
    access_config {
      // Cheaper, non-premium routing
      network_tier = "STANDARD"
    }
  }
}

resource "google_compute_instance_from_template" "struts2-24" {
  name         = "struts2-24"
  source_instance_template = "${local.default_windows}"
  network_interface {
    subnetwork="monkeyzoo-main"
    network_ip="10.2.2.24"
    access_config {
      // Cheaper, non-premium routing
      network_tier = "STANDARD"
    }
  }
}

resource "google_compute_instance_from_template" "jumpbox-252" {
  name                     = "jumpbox-252"
  source_instance_template = "${local.default_windows}"
  description              = "This machine is used to communicate with all other machines in the network."
  network_interface {
    subnetwork="monkeyzoo-main"
    network_ip="10.2.2.252"
    access_config {
      // Cheaper, non-premium routing
      network_tier = "STANDARD"
    }
  }
}

resource "google_compute_instance_from_template" "island-253" {
  name                     = "island-253"
  source_instance_template = "${local.default_windows}"
  description              = "This is the monkey island machine, that resebles the attacker in this network."
  network_interface {
    subnetwork="monkeyzoo-main"
    network_ip="10.2.2.253"
    access_config {
      // Cheaper, non-premium routing
      network_tier = "STANDARD"
    }
  }
}
