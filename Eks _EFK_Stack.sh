eksctl create cluster \
  --name eks-lab \
  --region ap-south-1 \
  --nodegroup-name eks-nodes \
  --nodes 2 \
  --node-type t3.medium \
  --node-volume-size 20 \
  --managed
