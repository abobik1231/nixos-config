{ config, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix  # Сгенерировано автоматически при установке
  ];

  # ─── Загрузчик ───────────────────────────────────────────────────────────────
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # ─── Hyper-V ─────────────────────────────────────────────────────────────────
  boot.initrd.kernelModules = [ "hv_vmbus" "hv_storvsc" ];
  boot.kernelParams = [ "video=hyperv_fb:1920x1080" ];
  boot.kernel.sysctl."vm.overcommit_memory" = "1";
  virtualisation.hypervGuest.enable = true;

  # ─── Сеть ────────────────────────────────────────────────────────────────────
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # ─── Время и локаль ──────────────────────────────────────────────────────────
  time.timeZone = "Asia/Yekaterinburg";
  i18n.defaultLocale = "ru_RU.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS        = "ru_RU.UTF-8";
    LC_IDENTIFICATION = "ru_RU.UTF-8";
    LC_MEASUREMENT    = "ru_RU.UTF-8";
    LC_MONETARY       = "ru_RU.UTF-8";
    LC_NAME           = "ru_RU.UTF-8";
    LC_NUMERIC        = "ru_RU.UTF-8";
    LC_PAPER          = "ru_RU.UTF-8";
    LC_TELEPHONE      = "ru_RU.UTF-8";
    LC_TIME           = "ru_RU.UTF-8";
  };

  # ─── Клавиатура ──────────────────────────────────────────────────────────────
  console.keyMap = "ru";

  # ─── Flakes ──────────────────────────────────────────────────────────────────
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Binary cache для Noctalia (ускоряет сборку)
  nix.settings.extra-substituters = [ "https://noctalia.cachix.org" ];
  nix.settings.extra-trusted-public-keys = [
    "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
  ];

  # ─── Графика / Wayland ───────────────────────────────────────────────────────
  hardware.graphics.enable = true;

  # XDG порталы (нужны для Hyprland)
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  };

  # ─── Hyprland ────────────────────────────────────────────────────────────────
  programs.hyprland = {
    enable = true;
    withUWSM = true;   # Рекомендуется для интеграции с systemd
    xwayland.enable = true;
  };

  # ─── Дисплей-менеджер (экран входа) ─────────────────────────────────────────
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd 'uwsm start hyprland-uwsm.desktop'";
        user = "greeter";
      };
    };
  };

  # ─── Звук ────────────────────────────────────────────────────────────────────
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # ─── Bluetooth ───────────────────────────────────────────────────────────────
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # ─── Управление питанием (нужно для Noctalia) ────────────────────────────────
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;

  # ─── Шрифты ──────────────────────────────────────────────────────────────────
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    (nerdfonts.override { fonts = [ "JetBrainsMono" "FiraCode" ]; })
  ];

  # ─── Пользователь ────────────────────────────────────────────────────────────
  users.users.august= {
    isNormalUser = true;
    description  = "august";
    extraGroups  = [ "wheel" "networkmanager" "video" "audio" ];
    shell        = pkgs.bash;
  };

  # sudo без пароля для wheel (удобно в ВМ)
  security.sudo.wheelNeedsPassword = false;

  # ─── Базовые системные пакеты ─────────────────────────────────────────────────
  environment.systemPackages = with pkgs; [
    git
    wget
    curl
    nano
    htop
    file
    unzip
    ripgrep
  ];

  # Переменная для Wayland-совместимости Electron-приложений
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # ─── Версия NixOS ────────────────────────────────────────────────────────────
  system.stateVersion = "25.05"; # Не меняй это значение!
}
