{ ... }:

{
  home.file.".config/rofi/config-emoji.rasi".text = # rasi
    ''
      @import "~/.config/rofi/config-long.rasi"
      entry {
        width: 45%;
        placeholder: "🔎 Search Emoji's 👀";
      }
    '';
}
