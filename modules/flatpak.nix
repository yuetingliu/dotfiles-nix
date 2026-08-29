{ ... }:

{
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
