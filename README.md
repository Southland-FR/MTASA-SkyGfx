![SKYGFX](doc/skygfx.png)
# MTASA-SkyGfx
A project brings the classic aesthetic look to MTA (Thanks to aap for the original work).
## What have done or working in progress?
- Pre-request Library
  * Timecyc Parser - ✔️
  * Timecyc Interpolation - ✔️, Source mainly conveted from librw, thanks to aap!
  * Timecyc Render - ✔️
  * Timecyc DebugTools (Optional) - DONE, But you're need dgs to work!
- Postfx 
  * Trails(Blur) - ✔️
  * Radiosity - ✔️
  * PS2 Color Filter - ✔️
- Building Pipeline
  * SimplePS - ✔️
  * BuildingVS - 🟠
    * partially, some engine data requires to work, still working on that
  * BuildingVSFX - For model with specular lighting property
    * Not even start yet
- Vehicle Pipeline
  * not even start yet
- no corona zTest
  * partially done, via shader, but will bug other 2dfx's zbuffer, need better solution
- PS2 Dual Pass Render - ✔️
  * Yeah, it's done, thanks to ren712
- PS2 Alpha Test
  * not even start yet
- Bugs/Issue
  * Sun can see through by walls -> Due to zTest disabled 