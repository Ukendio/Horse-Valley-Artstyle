# Axis Names / Transform terminology.

- X: Thickness
- Y: Height
- Z: Depth

## Dimension
- Wall Height: 12
- Wall Thickness: 0.25 wall
- Wall Depth: 0.25x,
- Floor height 0.2
- Floor dimension: (don't intersect with exterior walls),
- Door height 8.5
- Door side and top frames: 0.5
- Door width 4.5
- Door depth 1.0
- Furniture 0.125x
- Window Size: 0.25x

## Rotation
- Size.Y should be height (if it's not, it's rotated and wall textures will look bad for example)
- If wall has windows, fill vertically instead of horizontally. So 'll' instead of 'T'

Below are two images illustrating the aforementioned point made:

![Skärmbild 2022-01-14 114417](https://user-images.githubusercontent.com/68000848/149503097-dc11a090-98d0-4cc4-a89b-4eba77412277.png)
![Skärmbild 2022-01-14 114226](https://user-images.githubusercontent.com/68000848/149503104-c8ceaee2-0846-4710-b714-577f9494bcc2.png)


## Organization
- Exterior
    - door
    - roof
    - walls
    - misc
- Interior
    - room(1..n)
        - walls
        - ceiling 
        - floor

