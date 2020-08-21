#!/usr/bin/env python3.6
#

# coding: utf-8
# # Compare MCC to CohensKappa
# import packages
# In[ ]:

import numpy as np
import matplotlib.pyplot as plt

from random import seed
from random import randint
# seed(11)

# Generate confusion matrices by varying TPR, TNR and prevalence
# In[ ]:
stepsize = 0.01
vals = np.arange(0, 1. + stepsize, stepsize)
N = len(vals) - 1

# In[ ]:
TP = []
TN = []
FN = []
FP = []

for prev in vals:
    for TPR in vals:
        for TNR in vals:
            TP.append(prev*TPR)
            TN.append((1-prev) * TNR)
            FN.append(prev*(1-TPR))
            FP.append((1-prev)*(1-TNR))
            
TP = np.array(TP)
TN = np.array(TN)
FN = np.array(FN)
FP = np.array(FP)


# Calculate metrics
# In[ ]:
MCC_upper = TP * TN - FP * FN
MCC_lower = np.sqrt((TP +FP) * (TP + FN) * (TN + FP) * (TN +FN))
MCC = MCC_upper / MCC_lower


# Cohen's Kappa
kappa_upper = 2*(TP*TN - FP*FN)
kappa_lower = (TP + FP )*(FP + TN) + (TP + FN )*(FN + TN)
cohens_kappa = kappa_upper / kappa_lower




# plotting

# In[ ]:
plt.scatter(MCC, cohens_kappa)
plt.xlabel('Matthews correlation coefficient (MCC)')
plt.ylabel('Cohen\'s Kappa')
plt.grid()
# plt.show()

value = randint(1, 1000)

fileName = 'MCC_vs_CohensKappa_python_rand'+str(value)+'.png' 
plt.savefig(fileName)
