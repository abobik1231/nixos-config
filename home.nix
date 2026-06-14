{ config, pkgs, inputs, ... }:

{
  # ─── Home Manager ────────────────────────────────────────────────────────────
  home.username = "august";
  home.homeDirectory = "/home/august";
  home.stateVersion = "25.05"; # Не меняй!

  # ─── Noctalia Shell (через Home Manager модуль) ───────────────────────────────
  imports = [
    inputs.noctalia.homeModules.default
  ];

  programs.noctalia = {
    enable = true;
    systemd.enable = true; # Запускать через systemd user service

    settings = {
      theme = {
        mode   = "dark";
        source = "builtin";
        builtin = "Catppuccin";
      };

      wallpaper = {
        enabled = true;
        # Можно добавить путь к обоям позже:
        # default.path = "/home/august/Pictures/wallpaper.jpg";
      };
    };
  };

  # ─── Hyprland (пользовательская конфигурация) ────────────────────────────────
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false; # Отключаем — используем UWSM из system-конфига

    settings = {
      # Монитор (в ВМ обычно один)
      monitor = ",preferred,auto,1";

      # Клавиша-модификатор (Super = клавиша Windows)
      "$mod" = "SUPER";
      "$terminal" = "kitty";

      # Программы, запускаемые при старте
      exec-once = [
        "noctalia"   # Запустить Noctalia Shell
      ];

      # Общие настройки
      general = {
        gaps_in          = 5;
        gaps_out         = 10;
        border_size      = 2;
        "col.active_border"   = "rgba(cba6f7ff)"; # Фиолетовый (Catppuccin)
        "col.inactive_border" = "rgba(45475aff)";
        layout           = "dwindle";
      };

      # Украшения окон
      decoration = {
        rounding        = 10;
        blur.enabled    = true;
        blur.size       = 8;
        blur.passes     = 1;
        drop_shadow     = true;
        shadow_range    = 4;
        "col.shadow"    = "rgba(1a1a2eee)";
      };

      # Анимации
      animations = {
        enabled = true;
        bezier   = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      # Клавиши
      bind = [
        # Запустить терминал
        "$mod, Return, exec, $terminal"
        # Закрыть окно
        "$mod, Q, killactive"
        # Выход из Hyprland
        "$mod SHIFT, E, exit"
        # Fullscreen
        "$mod, F, fullscreen"
        # Floating toggle
        "$mod, V, togglefloating"
        # Переключение рабочих столов
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        # Переместить окно на рабочий стол
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        # Навигация по окнам
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"
      ];

      # Мышь
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
    };
  };

  # ─── Kitty Terminal ───────────────────────────────────────────────────────────
  programs.kitty = {
    enable = true;

    font = {
      name = "JetBrainsMono Nerd Font";
      size = 13;
    };

    settings = {
      # Тема Catppuccin Mocha (тёмная)
      background            = "#1e1e2e";
      foreground            = "#cdd6f4";
      selection_background  = "#f5e0dc";
      selection_foreground  = "#1e1e2e";
      cursor                = "#f5e0dc";
      cursor_text_color     = "#1e1e2e";

      # Цвета
      color0  = "#45475a";
      color1  = "#f38ba8";
      color2  = "#a6e3a1";
      color3  = "#f9e2af";
      color4  = "#89b4fa";
      color5  = "#f5c2e7";
      color6  = "#94e2d5";
      color7  = "#bac2de";
      color8  = "#585b70";
      color9  = "#f38ba8";
      color10 = "#a6e3a1";
      color11 = "#f9e2af";
      color12 = "#89b4fa";
      color13 = "#f5c2e7";
      color14 = "#94e2d5";
      color15 = "#a6adc8";

      # Прозрачность
      background_opacity = "0.95";

      # Прочее
      confirm_os_window_close = 0;
      window_padding_width    = 8;
    };
  };

  # ─── Базовые пользовательские пакеты ─────────────────────────────────────────
  home.packages = with pkgs; [
    # Браузер
    firefox

    # Файловый менеджер
    nautilus

    # Утилиты
    wofi          # Лаунчер приложений
    wl-clipboard  # Буфер обмена для Wayland
    grim          # Скриншоты
    slurp         # Выделение области для скриншота
    pavucontrol   # Управление звуком

    # Архивы
    p7zip
  ];

  # ─── Разрешить home-manager управлять собой ───────────────────────────────────
  programs.home-manager.enable = true;
}
