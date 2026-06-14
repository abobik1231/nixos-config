{
  description = "Моя NixOS конфигурация";

  inputs = {
    # Основной репозиторий пакетов (нестабильная ветка — самые свежие пакеты)
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home Manager — управление пользовательской конфигурацией
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Noctalia Shell v5
    noctalia = {
      url = "github:noctalia-dev/noctalia";
      # Не добавляем inputs.nixpkgs.follows чтобы использовать binary cache
    };
  };

  outputs = inputs @ { self, nixpkgs, home-manager, noctalia, ... }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = { inherit inputs; };
            users.august = import ./home.nix;
          };
        }
      ];
    };
  };
}
