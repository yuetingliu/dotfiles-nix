{ config, lib, pkgs, ... }:

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
  appindicatorSource = pkgs.gnomeExtensions.appindicator;
  appindicatorUuid = appindicatorSource.extensionUuid;
  appindicator = pkgs.runCommand "gnome-shell-extension-appindicator-no-ego-updates" {
    nativeBuildInputs = [ pkgs.jq ];
  } ''
    extension_dir="$out/share/gnome-shell/extensions/${appindicatorUuid}"
    mkdir -p "$extension_dir"
    cp -r ${appindicatorSource}/share/gnome-shell/extensions/${appindicatorUuid}/. "$extension_dir/"
    chmod -R u+w "$extension_dir"
    jq 'del(.version)' "$extension_dir/metadata.json" > "$extension_dir/metadata.json.tmp"
    mv "$extension_dir/metadata.json.tmp" "$extension_dir/metadata.json"
  '';
  # Explicitly typed empty arrays are needed by dconf's GVariant serializer.
  noKeys = lib.hm.gvariant.mkArray "s" [ ];
  numbered = count: make: lib.listToAttrs (
    lib.concatMap make (lib.range 1 count)
  );
  dropboxIndicatorIds = [ "dropbox-client" ]
    ++ map (n: "dropbox-client-${toString n}") (lib.range 1 20);
  dropboxIcon =
    "${config.home.homeDirectory}/.local/share/flatpak/exports/share/icons/hicolor/24x24/apps/com.dropbox.Client.png";
in
{
  # Imported only by linux.nix. Fedora supplies GNOME/Mutter, not Home Manager.
  xdg.dataFile."gnome-shell/extensions/${uuid}".source =
    "${extension}/share/gnome-shell/extensions/${uuid}";
  xdg.dataFile."gnome-shell/extensions/${appindicatorUuid}".source =
    "${appindicator}/share/gnome-shell/extensions/${appindicatorUuid}";

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
          appindicatorUuid
        ];
      };
      # Dropbox's status icons live inside the Flatpak sandbox. Point AppIndicator
      # at an absolute exported app icon; otherwise it searches Dropbox's private
      # IconThemePath for the override and falls back to the three-dot icon.
      # Dropbox suffixes the StatusNotifierItem id, so cover the observed range.
      "org/gnome/shell/extensions/appindicator".custom-icons =
        map (id: lib.hm.gvariant.mkTuple [ id dropboxIcon dropboxIcon ]) dropboxIndicatorIds;
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
