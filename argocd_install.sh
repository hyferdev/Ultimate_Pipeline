 #!/bin/bash
    curl -sL https://github.com/operator-framework/operator-lifecycle-manager/releases/download/v0.25.0/install.sh | bash -s v0.25.0
    kubectl create -f https://operatorhub.io/install/argocd-operator.yaml
    git clone https://github.com/hyferdev/argocd-basic.git ~/argo && chmod +r ~/argo
    kubectl apply -f ~/argo/argocd-basic.yml
    sleep 30
    kubectl patch svc argocd-server -p '{"spec": {"type": "NodePort"}}'
    kubectl get secret argocd-cluster -n default -o jsonpath='{.data.admin\.password}' | base64 -d
