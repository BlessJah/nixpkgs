{ config, pkgs, lib, ... }:

let
  cfg = config.services.suricata;
  configFile = pkgs.writeText "suricata.yaml" ''
    %YAML 1.1
    ---
    # Suricata configuration file. In addition to the comments describing all
    # options in this file, full documentation can be found at:
    # https://redmine.openinfosecfoundation.org/projects/suricata/wiki/Suricatayaml
    vars:
      address-groups:
        HOME_NET: "any"
        EXTERNAL_NET: "any"
      default-rule-path: ${cfg.rulesDir}
      rule-files:
        - emerging-exploit.rules
      classification-file: ${pkgs.suricata}/etc/suricata/classification.config
      reference-config-file: ${pkgs.suricata}/etc/suricata/reference.config
      default-log-dir: /tmp/var/log/suricata/
    outputs:
      - dns-log:
          enabled: yes
          filename: dns.log
          append: yes
      - fast:
          enabled: yes
          filename: fast.log
          append: yes/no
        - http-log:
            enabled: yes
            filename: http.log
            append: yes
    af-packet:
      - interface: eth0
  '';
in {
  options.services.suricata = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to enable suricata intrusion detection system (IDS).
      '';
    };
    rulesDir = lib.mkOption {
      type = lib.types.path;
      default = "/tmp/rules";
      description = ''
        Path for suricata rules.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.suricata.serviceConfig.ExecStart = "${pkgs.suricata}/bin/suricata -c ${configFile} --af-packet";
    systemd.services.suricata.serviceConfig.Type = "simple";
  };
}
