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

![Skärmbild 2022-01-14 113130](https://user-images.githubusercontent.com/68000848/149501563-ba259882-9593-4fb4-a78b-3042aa348c64.png)

![image](https://user-images.githubusercontent.com/68000848/149501525-7d279962-af80-4b8c-a90b-74506925fe64.png)


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

