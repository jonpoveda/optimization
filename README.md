# Optimization and Inference techniques in Computer Vision

[Module 2][m2] Project from [Master in Computer Vision
Barcelona][master] program.

## Inpainting
### Objective

Solve _Image Inpainting and Completion problem_ using basic optimization
methods used in computer vision.

![inpainting example][inpainting_example]

## Poisson Image Editing
### Objective

Replace a region from one image (source) to another (target) seamlessly.

![poisson editing example][poisson_example]

## Segmentation
### Objective

To smooth the boundary of the region to inpaint on the roof using the Chan-Vese segmentation model.

# References
<!-- APA stlye -->

- [Pérez, P., Gangnet, M., & Blake, A. (2003). Poisson image editing. ACM Transactions on graphics (TOG), 22(3), 313-318.][possion_ref]
- [Getreuer, P. (2012). Chan-vese segmentation. Image Processing On Line, 2, 214-224.][Chan-Vese segmentation]
- [T. F. Chan and L. A. Vese, "Active contours without edges," in IEEE Transactions on Image Processing, vol. 10, no. 2, pp. 266-277, Feb. 2001. doi: 10.1109/83.902291][Active contours without edges]

# Disclaimer

This software was designed to be used for research purposes. It is not
expected to have a good performance or even to follow programming good
practises.

[m2]: http://pagines.uab.cat/mcv/content/m2-optimization-and-inference-techniques-computer-vision-31819
[master]: http://pagines.uab.cat/mcv/
[possion_ref]: https://www.cs.virginia.edu/~connelly/class/2014/comp_photo/proj2/poisson.pdf
[inpainting_example]: docs/inpainting.png
[poisson_example]: docs/poisson_editing.png

[Active contours without edges]: http://www.math.ucla.edu/~lvese/PAPERS/IEEEIP2001.pdf
[Chan-Vese segmentation]: http://www.ipol.im/pub/art/2012/g-cv/article.pdf
