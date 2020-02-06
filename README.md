# MatMapper
A MATLAB-based function and GUI implementing the Mapper algorithm for use in Topological Data Analysis, or TDA. The algorithm was originally defined in:

>	Gurjeet Singh, Facundo Mémoli and Gunnar Carlsson, Topological Methods for the Analysis of High Dimensional Data Sets and 3D Object Recognition, Eurographics Symposium on Point Based Graphics, European Association for Computer Graphics, 2007, pp. 91–100, DOI 10.2312/SPBG/SPBG07/091-100 

The GUI allows for interactive investigation of how the Mapper algorithm works, and can help to build an intuivite understanding of what it does. It can also be useful for analysing and visualising the result of running Mapper on smaller datasets. Larger datasets ("big data") or more complex analyses will likely need a more advanced tool, or at the very least a computer with a lot of RAM for MATLAB to store all the data in.

# Known Issues
Here are some features which aren't currently working, and as I have moved on from this work into my PhD it may be a while before these get fixed. Fortunately there are some effective workarounds to provide the same functionality.
- Load From File. This can be bypassed through loading data into MATLAB and then loading From Workspace.
- Saving, except saving Data to Workspace. The Mapper output is exposed in MATLAB's workspace by saving it as the variable "G" and can be saved from there.
- To edit values in Clustering Settings > Other Settings, you first need to change the selected clustering algorithm.
- The "None" clustering setting. This can be bypassed by using k-means where k=1, which is functionally identical to the desired behaviour.

# MatMapperGUIDE.m
This is a GUI for interacting with the Mapper algorithm. It is best illustrated by watching the video below.

# Video Demonstrating the GUI
[![](http://img.youtube.com/vi/J0CJyZ4QTdo/0.jpg)](http://www.youtube.com/watch?v=J0CJyZ4QTdo "")

# mapper.m
This is the base function being called by the GUI, which may be useful for other applications where a full interface is not required. This takes input data, handles to a lens and clustering function, the number of buckets along each dimension of the lens to use, and the amount of overlap between lens buckets. It returns a MATLAB Graph object (https://au.mathworks.com/help/matlab/ref/graph.html) which is the output of the Mapper algorithm.

# Acknowledgements
This research was supported by the Asian Office of Aerospace Research and Development (grant FA2386-17-1-4007 and AOARD Grant 17IOA006), Defence Science and Technology Group, and the ARC Centre of Excellence for the Dynamics of Language (CE140100041).

# Citation
Software architecture paper in progress to be published on arXiv. In the interim, please cite as:
> D. Ferris, MatMapper, (2020), GitHub repository, https://github.com/VidFerris/MatMapper
