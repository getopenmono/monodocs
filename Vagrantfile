Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.provision "shell",
    path: "provision/set-utf8-locale"
  config.vm.provision "shell",
    path: "provision/development-setup-as-root"
  config.vm.provision "shell",
    path: "provision/development-setup-as-user",
    privileged: false
  config.vm.synced_folder ".", "/vagrant", rsync__exclude: [
    ".DS_Store"]
  config.vm.synced_folder "../mono_framework", "/mono_framework", rsync__exclude: [
    ".DS_Store"]
  config.vm.network "forwarded_port", guest: 8080, host: 8080
  # Avoid is-not-a-tty messages.
  config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"
end
