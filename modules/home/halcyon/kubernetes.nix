{pkgs, ...}: {
  programs.k9s = {
    enable = true;
  };

  home.packages = with pkgs; [
    kubectl
    kubernetes-helm
    cilium-cli
  ];

  home.shellAliases = {
    k = "kubectl";
    ka = "kubectl apply -f";
    kd = "kubectl delete -f";
  };
}
