# -*- mode: ruby -*-
# Lab Alertmanager + Prometheus — VM Debian 12 avec Docker
# Box utilisée : bento/debian-12 (déjà en cache local)

Vagrant.configure("2") do |config|
  config.vm.define "monitoring" do |mon|
    mon.vm.box      = "bento/debian-12"
    mon.vm.hostname = "monitoring"
    mon.vm.network  "private_network", ip: "10.0.50.10", virtualbox__intnet: "mon-net"

    # Ports forwardés vers l'hôte
    mon.vm.network "forwarded_port", guest: 9090, host: 9090, host_ip: "127.0.0.1"  # Prometheus
    mon.vm.network "forwarded_port", guest: 9093, host: 9093, host_ip: "127.0.0.1"  # Alertmanager
    mon.vm.network "forwarded_port", guest: 3000, host: 3000, host_ip: "127.0.0.1"  # Grafana
    mon.vm.network "forwarded_port", guest: 9100, host: 9100, host_ip: "127.0.0.1"  # Node-exporter

    mon.vm.provider "virtualbox" do |vb|
      vb.name   = "LAB-MONITORING"
      vb.memory = 2048
      vb.cpus   = 2
    end

    mon.vm.provision "shell", inline: <<-SHELL
      set -euo pipefail
      echo "=== Installation Docker + Docker Compose ==="
      apt-get update -qq
      apt-get install -y -qq ca-certificates curl gnupg

      install -m 0755 -d /etc/apt/keyrings
      rm -f /etc/apt/keyrings/docker.gpg
      curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --batch --yes --dearmor -o /etc/apt/keyrings/docker.gpg
      chmod a+r /etc/apt/keyrings/docker.gpg

      echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
https://download.docker.com/linux/debian $(. /etc/os-release && echo "$VERSION_CODENAME") stable" \
        > /etc/apt/sources.list.d/docker.list

      apt-get update -qq
      apt-get install -y -qq docker-ce docker-ce-cli containerd.io docker-compose-plugin

      usermod -aG docker vagrant
      systemctl enable --now docker

      echo "✅ Docker installé : $(docker --version)"
      echo "✅ Docker Compose : $(docker compose version)"

      # Créer le répertoire monitoring et copier les fichiers du lab
      mkdir -p /opt/monitoring/configs
      cp -r /vagrant/configs/. /opt/monitoring/configs/
      cp /vagrant/docker-compose.yml /opt/monitoring/
      # Créer alertmanager.yml depuis l'exemple si absent
      [ -f /opt/monitoring/configs/alertmanager.yml ] || \
        cp /opt/monitoring/configs/alertmanager.yml.example /opt/monitoring/configs/alertmanager.yml

      # Lancer la stack
      cd /opt/monitoring
      docker compose up -d

      echo ""
      echo "========================================"
      echo "  Stack monitoring démarrée"
      echo "  Prometheus   : http://localhost:9090"
      echo "  Alertmanager : http://localhost:9093"
      echo "  Grafana      : http://localhost:3000 (admin/admin)"
      echo "========================================"
    SHELL
  end
end
