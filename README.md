the code for A Vertical Federated Multiview Fuzzy Clustering Method for Incomplete Data
#Introduction
##Abstract
Multi-view fuzzy clustering (MVFC) has gained widespread adoption owing to its inherent flexibility in handling ambiguous data. The proliferation of privatization devices has driven the emergence of new challenge in MVFC researches. Federated learning, a technique that can jointly train without directly using raw data, has gain significant attention in decentralized MVFC. However, their applicability depends on the assumptions of data integrity and independence between different views. In fact, while within distributed environments, data typically exhibits two challenging problems: (1) multiple views within a single client; (2) incomplete data. Existing methods exhibit limitations in effectively addressing these challenges. Hence, in this study, we aim at achieving the effective clustering for incomplete data by a novel vertical federated MVFC framework. Specifically, a unified clustering framework is designed to capture both local client learning and global server training. For the local client learning, the data reconstruction strategy and prototype alignment strategy are introduced to ensure the preservation of data structure and refinement of clustering relationships, which mitigates the impact of incomplete data. Meanwhile, the global training process implements aggregation based on client-specific information. The whole process is realized based on the unified fuzzy clustering framework, promoting collaborative learning between client-specific and server information. Theoretical analyses and extensive experiments are carefully conducted to validate the effectiveness and efficiency of the proposed method from multiple perspectives.
This repo consists of four algorithms:
1.data 
2.main function: main_run
3.measure
#Citation
If you find our code useful, please cite:
@article{li2025vertical,
  title={A Vertical Federated Multi-View Fuzzy Clustering Method for Incomplete Data},
  author={Li, Yan and Hu, Xingchen and Yu, Shengju and Ding, Weiping and Pedrycz, Witold and Kiat, Yeo Chai and Liu, Zhong},
  journal={IEEE Transactions on Fuzzy Systems},
  year={2025},
  publisher={IEEE}
}
Thanks. 
