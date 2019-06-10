## Introduction

This is the code of SMCL (Self-Adaptive Multi-Prototype-based Competitive Learning)

Author: Yang Lu

Contact: lylylytc@gmail.com



## Usage

Directly run smcl.m with dataset name as argument. For example:

```shell
smcl.m gaussian
```



## Output Example

The codes output four figures and a set of numerical metrics.

![PNS_result](./figures/PNS_result.jpg)

![Global_measures](./figures/Global_measures.jpg)

![Ground_truth](./figures/Ground_truth.jpg)

![SMCL_clustering_result](./figures/SMCL_clustering_result.jpg)



## Datasets

Four synthetic datasets are provided:

1. gaussian
2. ids2
3. banana
4. lithanian

For the details of the datasets, please refer to the experiment part of the paper.



## Paper

Please cite the paper if the codes are helpful for you research

**Yang Lu**, Yiu-ming Cheung, and Yuan Yan Tang, "Self-Adaptive Multi-Prototype-based Competitive Learning Approach: A k-means-type Algorithm for Imbalanced Data Clustering", _IEEE Transactions on Cybernetics (TCYB)_, DOI:10.1109/TCYB.2019.2916196.