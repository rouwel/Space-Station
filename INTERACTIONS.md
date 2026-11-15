# Single-room station layout and interactions

The main scene contains the large central room only; four wall-colored panels block the cardinal openings. Existing GLBs are reused for the tank assemblies, oxygen control panel, data displays, bed, cabinets, storage, pipes, cables, and lights. Console/furniture details, junction boxes, rails, access hatches, floor plates, suit rack, and markings are made from lightweight Godot primitives and the project palette.

The room has an operations wall with a main power display, two auxiliary displays and a work console; a life-support cluster with oxygen controls, gauge, junctions and green supply runs to the tank assemblies; and habitation/stowage edges with the berth, bedside table, bench, lockers, containers and suit/helmet rack. Blue power cabling follows ceiling trays to the displays and follows the wall light run. Repeated ribs, vents, service hatches, removable floor plates, normal/warning/offline indicator colors, service caution markings and ochre floor route lines add station detailing. A few cool screen accents and red emergency indication use only two additional dynamic lights.

Wall-mounted GLBs are oriented to face into the room and positioned by their measured depth so their backs meet the wall plane instead of clipping through it. Their interaction colliders were adjusted to match those orientations. The four corner tank pairs sit against their nearest wall faces. Existing generated models were reused unchanged.

## Controls

- Look directly at a prop from within about 3.5 metres to see its prompt.
- Press **E** to interact.
- Press **E** or **Esc** to close an equipment panel.
- Panels release the cursor and block player movement/look. The fuel cell continues running.
- **Esc** retains the existing mouse-capture toggle when no panel is open.

## Life-support transfer demo

- The north-wall assembly has separate labeled hydrogen and oxygen vessels. **E** on the assembly gives a short direction message; it no longer opens a local oxygen panel. Use **Gas tanks** on the command computer for live percentages, quantities, and the oxygen-reserve setting.
- The fuel cell beside it opens a dedicated panel with start/stop, 25%/50%/100% output selection, consumption preview, and production totals.
- The northwest water tank opens a dedicated read-only water panel with stored quantity, free capacity, and incoming flow. A blue pipe connects it to the fuel cell through a conditioning block. Moving flow markers and an external level gauge show live transfer.
- Local equipment panels open as compact right-side overlays, with the station still visible and no tab navigation. Main and auxiliary screens at the operations console open the full central dashboard, including all tabs and controls. Every panel and physical readout uses the same simulation state.
- At 100% output, each real second consumes 0.005 kg hydrogen and 0.040 kg oxygen, producing 0.045 kg water and 0.5 energy units. Rates and energy units are accelerated game abstractions.
- Oxygen reserve protection stops the cell at 20% tank fill. Disabling it allows that reserve to be spent. Production also stops when either input runs out or either output store fills.
- The next-10-second preview accounts for available inputs and remaining storage. The overview tracks session production and a 1 kg water learning goal.
- **Reset demo**, available only at the central dashboard, restores initial resource quantities, tracking progress, and stops the cell. State also resets on a fresh F5 run.
- The command computer's **Science** tab follows the reference terminal layout, with **Observation**, **Data Log**, **Results**, and **Settings** views. Its tracking plot and estimates show an unknown object, predicted trajectory, 12,400 km estimated range, 0.8 km/s relative speed, outbound approach, and Station Array source.
- Observation 04 starts with the reference values (04:18:32, azimuth 128.4°, elevation 22.7°, confidence HIGH). **SUBMIT OBSERVATION** validates the entry and adds the accepted record to **Data Log**; **Results** reports its transmission. The oxygen-pressure notice is displayed above the submit control.
- Tracking values and orbital estimates are fictional gameplay data, not real measurements. The submitted record is session-only and resets with **Reset demo** or a fresh run.

## Food supplies and hydration

- The large wall cabinet to the left of the water-storage area is labeled **FOOD SUPPLIES**. **E** opens its dedicated inventory panel; the central dashboard also has a **Food** tab.
- Start with 6 dehydrated vegetable meals, 4 ready-to-eat stew pouches, and 4 powdered fruit drinks.
- Every action uses one sealed package and adds one prepared portion of that item. A meal uses 0.30 kg water; a drink uses 0.25 kg; opening a ready-to-eat pouch uses no added water. These quantities are explicit gameplay values.
- Costs are shown before preparation. A missing package or insufficient water disables that action and displays the reason.
- Water comes from the same corner tank used by the fuel cell. Its gauge and all panels update immediately. Fresh fuel-cell water can make a disabled recipe available again.
- Prepared portions remain in the shared inventory during the current run. **Reset demo** at the central console or a new F5 run resets food and water together.
- The Food panel links to NASA's Space Food Systems reference. Rehydration prepares food, rather than growing food or creating calories. Drinking-water demand and eating are future increments.

## Remaining prototype behavior

The bed gives brief rest feedback. Other lockers/container interactions toggle open/closed feedback without animating their one-piece models. Eating, crew metabolism, drinking-water demand, cabin oxygen/CO₂, electrolysis, solar generation, electrical loads, chemical oxygen cartridges, water recovery, heat management, and saved progress are not implemented yet. Water conditioning and food preparation are immediate abstractions. Existing decorative status lamps and screen graphs remain visual details; the new text readouts and water gauge reflect actual simulation state.
