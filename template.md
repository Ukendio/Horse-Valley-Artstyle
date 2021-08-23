## Dimension
- Wall Height: 12
- Wall Thickness: 0.25 wall
- Wall Length: 0.25x,
- Floor height 0.2
- Floor dimension: (don't intersect with exterior walls),
- Door height 8
- Door side and top frames: 0.25x
- Door width 4.5
- Furniture 0.05x increments .. 0.125?
- Window Size: 0.25x

## Rotation
- Size.Y should be height (if it's not, it's rotated and wall textures will look bad for example)
- If wall has windows, fill vertically instead of horizontally. So 'll' instead of 'T'

## Organization
- Exterior
    - door
    - roof
    - walls
    - misc
- Interior
    - room1..=room[n]
        -walls
        -ceiling
        -floor

