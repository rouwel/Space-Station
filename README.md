# NASA space station

A playable lunar-outpost prototype for the NASA Space Apps challenge, aimed at
learners aged 10–14. Students will explore engineering trade-offs between air,
water, power, and food through connected systems.

## Run

Godot **4.7.2 stable**, standard edition, is pinned in `mise.toml`.

```sh
mise exec -- godot --editor --path .
```

Let imports finish, then press **F5**. Use WASD, mouse look, **E** to interact,
and **E/Esc** to close a panel. See [INTERACTIONS.md](INTERACTIONS.md).

## Current checkpoint: fuel-cell loop and food hydration

Implemented:

- Separate H₂/O₂ vessels, live tank percentages, fuel-cell controls, and a corner
  water-storage tank with a level gauge and animated transfer markers.
- Dedicated local panels for gas tanks, fuel cell, water storage, and food supplies,
  sharing live state with the central dashboard's Overview, Gas tanks, Power,
  Water, Food, and Science tabs.
- Finite food packages, water-dependent preparation, ready-portion inventory,
  visible costs, and stock/water shortage feedback.
- Equipment-specific controls locally; overall navigation and Reset Demo at the
  central console.
- Finite input/output accounting, adjustable production, optional oxygen reserve
  protection, session totals, a short learning goal, and reset.
- Mouse-enabled panels that block movement while simulation continues.

Next increments:

1. Eating, drinking/crew demand, electrolyzer, solar/battery loads, and
   independent CO₂ removal.
2. Emergency oxygen cartridges, delayed water recovery, a solar-input fault,
   and a decision-focused debrief.
3. Food production and radiation/shielding trade-offs.

Contributor ownership and release organization will be agreed before publishing.
Local commits record the baseline and each working increment using configured Git
identity; they do not assign future contributor roles.

## Simulation assumptions

`scripts/life_support_state.gd` owns the live quantities. Panels and equipment
subscribe to its `changed` signal; closing UI never restarts the simulation.

- Rounded reaction mass balance: **1 kg H₂ + 8 kg O₂ → 9 kg H₂O**.
- Initial stores: 0.8/1 kg H₂, 6.4/8 kg O₂, 2/12 kg water, 20/100 energy units.
- Full-output rate: 0.005 kg H₂ per real second, with proportional O₂, water,
  and electrical output. Lower output scales every quantity together.
- 100 energy units per kg H₂ is a balancing value, not a hardware specification.
- Reaction extent is limited by both gas supplies and both output capacities.
  No inputs are spent on output that cannot be stored.
- The 1.6 kg protected oxygen reserve is an allocation rule, not a cabin-air model.
- Water conditioning is immediate/abstracted; heat is explained but not simulated.
- This is a proposed educational lunar system, not a replica of deployed hardware.
- Future electrolysis must cost more electricity than a fuel-cell round trip yields.
- Initial food stock: 6 dehydrated meals (0.30 kg preparation water each), 4
  ready-to-eat pouches (no added water), and 4 drink packets (0.25 kg each).
  Each sealed package becomes exactly one prepared portion.
- Meal water quantities are gameplay values and preparation is immediate. Water
  used for food is tracked separately from tank water; it is not instantly recycled.
- Preparing food creates neither new food nor calories. Eating, nutrition,
  drinking requirements, and replenishment of food stock are not simulated yet.

## Verification

No test framework or extra packages are required:

```sh
mise exec -- godot --headless --path . --editor --import
mise exec -- godot --headless --path . --script tools/test_life_support.gd
```

The test script checks mass/resource accounting, reserve and capacity boundaries,
large time steps, frame-rate independence, food stock/water transactions and
shortages, and integration with screens, physical readouts, and player modal controls.
A rendered run of the same script checks
mouse behavior with a real display.

To capture the room and panels using Godot's renderer, pass an existing directory:

```sh
mise exec -- godot --path . --script tools/capture_life_support.gd -- /tmp/opencode
```

This opens a temporary game window, captures PNGs at fixed viewport sizes
(independent of window-manager tiling), and exits. For hands-on review,
start the cell, collect 1 kg of new water, close the panel and inspect the corner
tank, then return to the fuel cell or central console and stop production.
Open the labeled food cabinet, hydrate a meal, and check that the tank loses
0.30 kg while the prepared-meal count increases. Reopen Food at the central
console to see the same inventory.

## Scientific references

- [Smithsonian: Apollo astronaut life](https://airandspace.si.edu/explore/stories/apollo-astronaut-life)
- [NASA: Apollo fuel cells](https://www.nasa.gov/technology/tech-transfer-spinoffs/tech-today-nasas-moonshot-launched-commercial-fuel-cell-industry/)
- [NASA: Regenerative fuel-cell testing](https://www.nasa.gov/general/nasa-regenerative-fuel-cell-testing/)
- [NASA: Environmental control and life support](https://www.nasa.gov/reference/environmental-control-and-life-support-systems-eclss/)
- [NASA: Space Food Systems](https://www.nasa.gov/humans-in-space/space-food-systems/)
