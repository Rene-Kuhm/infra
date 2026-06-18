{ config, lib, pkgs, ... }:

{
  # Locale
  i18n.defaultLocale = "es_AR.UTF-8";
  i18n.supportedLocales = [ "en_US.UTF-8/UTF-8" "es_AR.UTF-8/UTF-8" ];

  # Keyboard
  services.xserver.xkb.layout = "latam";

  # Time
  time.timeZone = "America/Buenos_Aires";

  # Console keyboard
  console.keyMap = "la-latin1";
}