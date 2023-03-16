{
  description = "Vulsn Prometheus Exporter";

  inputs.devshell.url = "github:numtide/devshell";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, flake-utils, devshell, nixpkgs }:
    flake-utils.lib.eachDefaultSystem (system: 
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ devshell.overlay ];
          };
          vuls-exporter = pkgs.buildGoModule rec {
            pname = "vuls-exporter";
            version = "0.0.1";
            src = pkgs.lib.cleanSource ./src;
            vendorSha256 = "sha256-mtJplms4nCOLQipkPIEyNgNTBO6BWNpPUezKuZ/mhHE=";
            proxyVendor = true;
          };
        in rec { 
          devShell = pkgs.devshell.mkShell {
            imports = [ (pkgs.devshell.importTOML ./devshell.toml) ];
          };
          packages = { 
            vuls-exporter = vuls-exporter;
            default = vuls-exporter;
          };
    });
}
