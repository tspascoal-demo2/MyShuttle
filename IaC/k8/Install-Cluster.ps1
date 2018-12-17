
param(
    $ResourceGroup = "TspK8",
    $ClusterName = "tspK8",
    $K8Version = "1.11.5",
    $region = "westeurope",
    $VmSize = "Standard_DS3_v2",
    [switch]
    $DeleteKubeAndHelm = $false
)


if($DeleteKubeAndHelm -eq $true) {
    $null = Remove-Item ~\.kube -Recurse -Force
    $null = Remove-Item ~\.helm -Recurse -Force
}

az group create -l $region -n $ResourceGroup

if(Test-Path $Env:SystemDrive\$Env:HOMEPATH\.ssh\id_rsa.pub) {
    Write-Host "using existing ssh key"
} else {
    Write-Host "Will create a new ssh key"
    $createKey = "--generate-ssh-keys"
}

$null=az aks create -n $ClusterName -g $ResourceGroup --node-count 1 $createKey `
--node-vm-size $VmSize --kubernetes-version $K8Version

$null=az aks get-credentials -n $ClusterName -g $ResourceGroup

kubectl apply -f helm-rbac.yml
kubectl create clusterrolebinding kubernetes-dashboard --clusterrole=cluster-admin --serviceaccount=kube-system:kubernetes-dashboard
kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller

kubectl create clusterrole system:azure-cloud-provider --verb=get,create --resource=secrets
kubectl create clusterrolebinding system:azure-cloud-provider --clusterrole=system:azure-cloud-provider --serviceaccount=kube-system:persistent-volume-binder

# kubectl patch deploy --namespace kube-system tiller-deploy -p '{"spec":{"template":{"spec":{"serviceAccount":"tiller"}}}}'

Write-Host "Installing Helm"

helm init --service-account tiller
helm init --service-account tiller --client-only

