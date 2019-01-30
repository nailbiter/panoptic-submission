This repository is forked from
https://github.com/GeorgeSeif/Semantic-Segmentation-Suite.

I intend to use it in a
[COCO 2018 Panoptic Segmentation Task](http://cocodataset.org/index.htm#panoptic-2018) competition.

Initially, my strategy was to:

1. Create a general framework to combine the results of object detection and
stuff detection algorithms into the results of panoptic (as in [1])
1. Enable this framework to insert the "blank" implementation for either of algorithms (i.e. algorithm, outputting nothing)
1. First try this algorithm with different versions of stuff detection
1. Then add an implementation of an object detection

At this moment, I am stuck on a third step.
I decided to start with stuff segmentation, as when converting from object
segmentation to panoptic segmentation, one should be careful about overlaps
(see [1]) and this includes additional complexity.

## References

1. [panoptic segmentation paper](https://arxiv.org/abs/1801.00868)

[1]: https://arxiv.org/abs/1801.00868
