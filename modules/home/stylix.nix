{inputs, ...}: {
  imports = [inputs.stylix.nixosModules.stylix];
  stylix.image = ./background.jpg;
}
