{ pkgs }:
pkgs.writeShellScriptBin "pdf-viewer" ''
  file=$(find . -maxdepth 1 -type f \( -name "*.pdf" -o -name "*.djvu" \) | fzf)
  if [ -n "$file" ]; then
      case "$file" in
          *.pdf)
              ${pkgs.zathura}/bin/zathura "$file" &>/dev/null & disown
              ;;
          *.djvu)
              ${pkgs.zathura}/bin/zathura "$file" &>/dev/null & disown
              ;;
      esac
  fi
''
