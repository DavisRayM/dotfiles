{config, ...}: {
  boot.initrd.kernelModules = ["amdgpu"];
  services.supergfxd = {
    enable = true;
  };
  services.asusd = {
    enable = true;
    enableUserService = true;
  };
  services.power-profiles-daemon.enable = true;

  hardware.graphics.enable = true;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
  hardware.nvidia.modesetting.enable = true;
  hardware.nvidia.powerManagement.enable = true;
  hardware.nvidia.powerManagement.finegrained = true;
  hardware.nvidia.open = true;
  hardware.nvidia.nvidiaSettings = true;
  hardware.nvidia.prime = {
    sync.enable = true;
    nvidiaBusId = "PCI:01:00:0";
    amdgpuBusId = "PCI:05:00:0";
  };

  programs.rog-control-center.enable = true;
}
