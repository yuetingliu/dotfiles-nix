{ ... }:

{
  # Launch the same Flatpak as the application menu (not a host Dropbox
  # daemon). Flatpak's launcher keeps concurrent starts single-instance.
  xdg.configFile."autostart/com.dropbox.Client.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=Dropbox
    Exec=flatpak run com.dropbox.Client
    Icon=com.dropbox.Client
    Terminal=false
    X-GNOME-Autostart-enabled=true
  '';

  services.flatpak = {
    enable = true;
    packages = [
      "com.brave.Browser"
      "com.dropbox.Client"
      "com.spotify.Client"
      "org.gimp.GIMP"
      "org.localsend.localsend_app"
    ];

    update.auto = {
      enable = true;
      onCalendar = "weekly";
    };
  };
}
