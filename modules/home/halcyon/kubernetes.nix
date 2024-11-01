{
  config,
  pkgs,
  ...
}: {
  programs.k9s = {
    enable = true;
    settings = {
      k9s = {
        liveViewAutoRefresh = true;
        maxConnRetry = 5;
        ui = {
          enableMouse = true;
          crumbsless = true;
          reactive = true;
        };
        skipLatestRevCheck = true;
        imageScans = {
          enable = true;
        };
        logger = {
          tail = 500;
          buffer = 10000;
          fullScreen = true;
        };
      };
    };
  };

  home.packages = with pkgs; [
    kubectl
    krew
    kubernetes-helm
    cilium-cli
  ];

  home.sessionVariables = {
    KREW_ROOT = "${config.xdg.dataHome}/krew";
  };

  home.sessionPath = [
    "$KREW_ROOT/bin"
  ];

  home.shellAliases = {
    k = "kubectl";
    ka = "kubectl apply -f";
    kd = "kubectl delete -f";
  };
}
