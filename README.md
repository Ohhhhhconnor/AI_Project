# Activity Recognition for Automatic Music Selection

Artificial Intelligence project - Conducted by Jordan O'Connor and Bryan Beatrez for AI Explorations (EEEE54701.2141) at the Rochester Institute of Technology.

Much of this code is adopted from the Cornell Robot Learning Lab. Computer Science Department, Cornell University. http://pr.cs.cornell.edu/humanactivities/index.php

## Included Files
### Project Files
Included in this folder is code to generate our classified training data, apply our algorithms and calculate our results. https://github.com/Ohhhhhconnor/AI_Project/tree/master/project_files

### Video Data
Included in this folder is the CSV files needed to generate the joint skeleton, which is used for the training data in the Project Files. https://github.com/Ohhhhhconnor/AI_Project/tree/master/video_data

## Usage Notes
1. Download the project zip files from the github page: https://github.com/Ohhhhhconnor/AI_Project
2. In MATLAB, add the project files to the path. 
3. To generate our current results, run the apply_training_data.m script in MATLAB. If you would like to edit the number of frames in the training data, the variable frames_per_video should be edited in the files apply_training_data.m, generate_training_data.m and generate_classification_array.m. Then, proceed to step 4.
4. To use more frames, after updating the frames_per_video variable, run the generate_training_data.m script and allow it to finish. The generated file will be indicated at the end of the script (the path can be edited at the end of generate_training_data.m).
5. Run apply_training_data.m to generate the new results. 

## 
