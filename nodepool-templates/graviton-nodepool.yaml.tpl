---
apiVersion: eks.amazonaws.com/v1
kind: NodeClass
metadata:
  name: graviton-nodeclass
spec:
  role: ${node_iam_role_name}
  subnetSelectorTerms:
    - tags:
        karpenter.sh/discovery: "automode-demo"
  securityGroupSelectorTerms:
    - tags:
        kubernetes.io/cluster/automode-cluster: owned
  tags:
    karpenter.sh/discovery: "automode-demo"
---
apiVersion: karpenter.sh/v1
kind: NodePool
metadata:
  name: graviton-nodepool
spec:
  template:
    spec:
      nodeClassRef:
        group: eks.amazonaws.com
        kind: NodeClass
        name: graviton-nodeclass
      requirements:
        - key: "eks.amazonaws.com/instance-category"
          operator: In
          values: ["c", "t"]
        - key: "eks.amazonaws.com/instance-cpu"
          operator: In
          values: ["2", "8"]
        - key: "kubernetes.io/arch"
          operator: In
          values: ["arm64"]
        - key: "karpenter.sh/capacity-type"
          operator: In
          values: ["spot"]          
      taints:
        - key: "arm64"
          value: "true"
          effect: "NoSchedule"
  limits:
    cpu: 1000
  disruption:
    consolidationPolicy: WhenEmpty
    consolidateAfter: 30s
