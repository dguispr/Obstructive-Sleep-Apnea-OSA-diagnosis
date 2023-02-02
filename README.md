# Obstructive-Sleep-Apnea-OSA-diagnosis
Diagnosis of obstructive sleep apnea by Dual-Convolutional Dual-Attention Network (DCDA-Net) using magnified scalograms transformed from the magnified time-domain ECG segments
Dataset used in this project is Apnea-ECG from Physionet.
Anybody can read the annotations using 'rdann' function.
The detection of R-peaks is somehow tricky because there are some transient artifacts having higher apmlitude than R-peaks therefore, it is very important to understand the code (of scalogram magnification) for your problem.
