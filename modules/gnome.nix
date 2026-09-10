{ lib, pkgs, ... }:

let
  uuid = "manual-layout@dotfiles-nix";
  extension = pkgs.runCommand "gnome-shell-extension-manual-layout" {
    nativeBuildInputs = [ pkgs.glib pkgs.nodejs ];
  } ''
    export EXTENSION_DIR="$out/share/gnome-shell/extensions/${uuid}"
    mkdir -p "$EXTENSION_DIR"
    cp -r ${../dotfiles/config/gnome}/${uuid}/. "$EXTENSION_DIR/"
    chmod -R u+w "$EXTENSION_DIR"
    glib-compile-schemas --strict "$EXTENSION_DIR/schemas"
    node --check "$EXTENSION_DIR/extension.js"
    node --experimental-vm-modules --test ${../tests/gnome-window-management.mjs}
  '';
  # Explicitly typed empty arrays are needed by dconf's GVariant serializer.
  noKeys = lib.hm.gvariant.mkArray "s" [ ];
  numbered = count: make: lib.listToAttrs (
    lib.concatMap make (lib.range 1 count)
  );
in
{
  # Imported only by linux.nix. Fedora supplies GNOME/Mutter, not Home Manager.
  xdg.dataFile."gnome-shell/extensions/${uuid}".source =
    "${extension}/share/gnome-shell/extensions/${uuid}";

  dconf = {
    enable = true;
    settings = {
      "org/gnome/mutter" = {
        dynamic-workspaces = false;
        workspaces-only-on-primary = false;
      };
      "org/gnome/desktop/wm/preferences".num-workspaces = 6;
      "org/gnome/desktop/wm/keybindings" = (numbered 6 (n: [
        {
          name = "switch-to-workspace-${toString n}";
          value = [ "<Super>${toString n}" ];
        }
        {
          name = "move-to-workspace-${toString n}";
          value = [ "<Super><Shift>${toString n}" ];
        }
      ])) // {
        minimize = [ "<Control><Super>m" ];
        cycle-windows = [ "<Super>l" ];
        cycle-windows-backward = [ "<Super><Shift>l" ];
        # No application-level switching; retain window/group shortcuts.
        switch-applications = noKeys;
        switch-applications-backward = noKeys;
      };
      "org/gnome/shell/window-switcher".current-workspace-only = true;
      "org/gnome/settings-daemon/plugins/media-keys".screensaver = [ "<Control><Alt>l" ];
      "org/gnome/shell/keybindings" = numbered 9 (n: [
        {
          name = "switch-to-application-${toString n}";
          value = noKeys;
        }
        {
          name = "open-new-window-application-${toString n}";
          value = noKeys;
        }
      ]);
      "org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = [
          # Preserve the only extension enabled on this Fedora installation.
          "background-logo@fedorahosted.org"
          uuid
        ];
      };
      "org/gnome/shell/extensions/manual-layout" = {
        gap = 12;
        arrange-left = [ "<Control><Super>h" ];
        arrange-right = [ "<Control><Super>l" ];
        arrange-top = [ "<Control><Super>k" ];
        arrange-bottom = [ "<Control><Super>j" ];
        fill = [ "<Control><Super>f" ];
        center = [ "<Control><Super>c" ];
      };
    };
  };
}
